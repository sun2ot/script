// ==UserScript==
// @name         AutoCaptcha
// @description  智能填表。支持 OpenAI/Gemini/通义千问。自动处理文本验证码；按住 [Alt+点击] 图片强制识别，再点击输入框填入。可选手动模式。
// @version      3.4.0
// @author       sun2ot
// @license      AGPL-3.0-or-later
// @match        *://*/*
// @noframes
// @grant        GM_setValue
// @grant        GM_getValue
// @grant        GM_registerMenuCommand
// @grant        GM_xmlhttpRequest
// @grant        GM_setClipboard
// @connect      *
// @run-at       document-end
// @updateURL    https://raw.githubusercontent.com/sun2ot/script/main/Tampermonkey/AutoCaptcha.user.js
// @downloadURL  https://raw.githubusercontent.com/sun2ot/script/main/Tampermonkey/AutoCaptcha.user.js
// ==/UserScript==

(function () {
    'use strict';

    const SECURITY = {
        TYPE_BLACKLIST: [
            'password', 'email', 'search', 'url', 'date', 'datetime-local',
            'month', 'week', 'time', 'color', 'file', 'hidden', 'image',
            'submit', 'button', 'reset', 'checkbox', 'radio', 'range'
        ],
        KEYWORD_BLACKLIST: [
            'user', 'login', 'account', 'pwd', 'pass', 'auth', 'token', 'csrf',
            'mail', 'phone', 'mobile', 'address', 'search', 'query', 'wd', 'keyword',
            'title', 'content', 'msg', 'price', 'amount'
        ],
        KEYWORD_WHITELIST: [
            'captcha', 'yzm', 'verification', 'verify', 'vcode', 'checkcode',
            '验证码', '校验', 'code'
        ]
    };

    class Config {
        static KEY = 'ai_captcha_config_v3';
        static DEFAULTS = {
            provider: 'openai',
            manualMode: false,
            openai: {
                baseUrl: 'https://api.openai.com/v1/chat/completions',
                apiKey: '',
                model: 'gpt-4o-mini',
                textPrompt: 'Extract the captcha from the image and output only the final answer. If unclear, output nothing.'
            },
            gemini: {
                baseUrl: 'https://generativelanguage.googleapis.com/v1beta/models',
                apiKey: '',
                model: 'gemini-2.0-flash',
                textPrompt: 'Extract the captcha from the image and output only the final answer. If unclear, output nothing.'
            },
            qwen: {
                baseUrl: 'https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions',
                apiKey: '',
                model: 'qwen-vl-max',
                textPrompt: 'Extract the captcha from the image and output only the final answer. If unclear, output nothing.'
            },
            selectors: [
                'img[src*="captcha" i]', 'img[src*="verify" i]', 'img[src*="code" i]', 'img[src*="validate" i]', 'img[src*="random" i]',
                'img[id*="captcha" i]', 'img[id*="verify" i]', 'img[id*="code" i]', 'img[id*="checkcode" i]', 'img[id*="vcode" i]', 'img[id*="auth" i]',
                'img[class*="captcha" i]', 'img[class*="verify" i]', 'img[class*="code" i]', 'img[class*="vcode" i]',
                'img[alt*="captcha" i]', 'img[alt*="verify" i]', 'img[alt*="code" i]', 'img[alt*="验证码" i]',
                'img[title*="captcha" i]', 'img[title*="verify" i]', 'img[title*="code" i]', 'img[title*="验证码" i]'
            ]
        };

        static #data = null;

        static load() {
            try {
                const stored = GM_getValue(this.KEY);
                this.#data = stored ? { ...this.DEFAULTS, ...JSON.parse(stored) } : { ...this.DEFAULTS };
                ['openai', 'gemini', 'qwen'].forEach(k => {
                    this.#data[k] = { ...this.DEFAULTS[k], ...(this.#data[k] || {}) };
                });
            } catch { this.#data = { ...this.DEFAULTS }; }
        }

        static get() { if (!this.#data) this.load(); return this.#data; }

        static save(d) {
            this.#data = { ...this.#data, ...d };
            GM_setValue(this.KEY, JSON.stringify(this.#data));
        }
    }

    class AI {
        static async solve(base64) {
            const conf = Config.get();
            const cfg = conf[conf.provider];
            if (!cfg.apiKey) throw new Error('API Key 未配置');

            const prompt = cfg.textPrompt || Config.DEFAULTS[conf.provider].textPrompt;
            const cleanBase64 = base64.replace(/^data:image\/\w+;base64,/, '');

            if (conf.provider === 'gemini') return this.#gemini(cfg, cleanBase64, prompt);
            return this.#openai(cfg, base64, prompt);
        }

        static async #openai(cfg, imgUrl, prompt) {
            const body = {
                model: cfg.model,
                messages: [{
                    role: 'user',
                    content: [
                        { type: 'text', text: prompt },
                        { type: 'image_url', image_url: { url: imgUrl } }
                    ]
                }],
                max_tokens: 16,
                temperature: 0
            };
            const res = await this.request('POST', cfg.baseUrl, { 'Authorization': `Bearer ${cfg.apiKey}` }, body);
            if (res.error) throw new Error(res.error.message);
            return res.choices?.[0]?.message?.content?.trim();
        }

        static async #gemini(cfg, b64, prompt) {
            const url = `${cfg.baseUrl}/${cfg.model}:generateContent?key=${cfg.apiKey}`;
            const body = {
                contents: [{ parts: [{ text: prompt }, { inline_data: { mime_type: 'image/png', data: b64 } }] }]
            };
            const res = await this.request('POST', url, {}, body);
            if (res.error) throw new Error(res.error.message);
            return res.candidates?.[0]?.content?.parts?.[0]?.text?.trim();
        }

        static request(method, url, headers, body) {
            return new Promise((resolve, reject) => {
                GM_xmlhttpRequest({
                    method, url, timeout: 30000,
                    headers: body === undefined ? { ...headers } : { 'Content-Type': 'application/json', ...headers },
                    data: body === undefined ? undefined : JSON.stringify(body),
                    onload: r => {
                        if (r.status >= 200 && r.status < 300) {
                            try { resolve(JSON.parse(r.responseText)); }
                            catch { reject(new Error('Bad JSON')); }
                            return;
                        }
                        reject(new Error(`HTTP ${r.status}`));
                    },
                    onerror: () => reject(new Error('Network Error'))
                });
            });
        }
    }

    class ModelService {
        static async list(provider, overrides = {}) {
            const conf = Config.get();
            const cfg = { ...conf[provider], ...overrides };
            if (!cfg.apiKey) throw new Error('No API Key');
            return provider === 'gemini' ? this.#listGemini(cfg) : this.#listOpenAI(cfg);
        }

        static async #listOpenAI(cfg) {
            const url = this.#openaiListUrl(cfg.baseUrl);
            const res = await AI.request('GET', url, { 'Authorization': `Bearer ${cfg.apiKey}` });
            const models = (res.data || []).map(m => m.id).filter(Boolean);
            if (!models?.length) throw new Error('No models returned');
            return models;
        }

        static #openaiListUrl(url) {
            const cleaned = url.replace(/\/v1\/.*$/, '/v1/models');
            return cleaned.includes('/models') ? cleaned : `${cleaned}/models`;
        }

        static async #listGemini(cfg) {
            const url = this.#geminiListUrl(cfg.baseUrl, cfg.apiKey);
            const res = await AI.request('GET', url, {});
            const models = (res.models || []).map(m => m.name?.split('/').pop()).filter(Boolean);
            if (!models?.length) throw new Error('No models returned');
            return models;
        }

        static #geminiListUrl(baseUrl, key) {
            const base = baseUrl.replace(/\/:generateContent.*$/, '').replace(/\/models\/?$/, '/models');
            const root = base.includes('/models') ? base : `${base}/models`;
            return `${root}?key=${key}`;
        }
    }

    class UiManager {
        #host; #shadow; #indicator; #toastTimer;

        constructor(onOpenSettings) {
            this.#initShadowDOM(onOpenSettings);
        }

        #initShadowDOM(onOpenSettings) {
            this.#host = document.createElement('div');
            this.#host.style.cssText = 'position: fixed; bottom: 0; right: 0; width: 0; height: 0; z-index: 2147483647;';
            document.body.appendChild(this.#host);
            this.#shadow = this.#host.attachShadow({ mode: 'closed' });

            const style = document.createElement('style');
            style.textContent = `
                :host { font-family: system-ui, -apple-system, sans-serif; }
                .indicator { position: fixed; bottom: 15px; right: 15px; width: 12px; height: 12px; border-radius: 50%; background: #9CA3AF; box-shadow: 0 0 10px rgba(0,0,0,0.1); cursor: pointer; transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); z-index: 10000; border: 2px solid white; }
                .indicator:hover { transform: scale(1.3); }
                .indicator::after { content: attr(data-title); position: absolute; right: 20px; bottom: -4px; background: rgba(0,0,0,0.8); color: #fff; padding: 4px 10px; border-radius: 4px; font-size: 12px; white-space: nowrap; opacity: 0; visibility: hidden; transition: all 0.2s; pointer-events: none; }
                .indicator:hover::after { opacity: 1; visibility: visible; right: 25px; }
                .status-idle { background: #10B981; box-shadow: 0 0 8px #10B981; animation: breathe 3s infinite; }
                .status-processing { background: #3B82F6; box-shadow: 0 0 12px #3B82F6; animation: blink 0.8s infinite; }
                .status-error { background: #EF4444; box-shadow: 0 0 8px #EF4444; }
                .toast { position: fixed; bottom: 45px; right: 15px; padding: 8px 14px; background: rgba(31, 41, 55, 0.9); color: white; border-radius: 8px; font-size: 13px; opacity: 0; transform: translateY(10px); transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); pointer-events: none; backdrop-filter: blur(4px); box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1); display: flex; align-items: center; gap: 6px; }
                .toast.show { opacity: 1; transform: translateY(0); }
                .modal-backdrop { position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; background: rgba(0,0,0,0.3); backdrop-filter: blur(2px); display: flex; justify-content: center; align-items: center; opacity: 0; visibility: hidden; transition: all 0.2s; z-index: 10001; }
                .modal-backdrop.open { opacity: 1; visibility: visible; }
                .modal-card { background: white; padding: 24px; border-radius: 16px; width: 400px; max-height: 90vh; overflow-y: auto; box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1); transform: scale(0.95); transition: transform 0.2s; }
                .modal-backdrop.open .modal-card { transform: scale(1); }
                .form-group { margin-bottom: 12px; }
                .form-label { display: block; font-size: 12px; color: #4B5563; margin-bottom: 4px; font-weight: 500; }
                .form-input { width: 100%; padding: 8px 12px; border: 1px solid #D1D5DB; border-radius: 6px; font-size: 14px; outline: none; transition: border-color 0.2s; box-sizing: border-box; }
                .form-input:focus { border-color: #3B82F6; }
                .form-textarea { width: 100%; padding: 8px 12px; border: 1px solid #D1D5DB; border-radius: 6px; font-size: 13px; outline: none; transition: border-color 0.2s; box-sizing: border-box; resize: vertical; min-height: 60px; }
                .form-textarea:focus { border-color: #3B82F6; }
                .btn { padding: 6px 16px; border-radius: 6px; border: none; cursor: pointer; font-size: 14px; font-weight: 500; transition: background 0.2s; }
                .btn-primary { background: #2563EB; color: white; }
                .btn-primary:hover { background: #1D4ED8; }
                .btn-secondary { background: #F3F4F6; color: #374151; margin-right: 8px; }
                .btn-secondary:hover { background: #E5E7EB; }
                .btn-small { padding: 4px 12px; font-size: 12px; }
                .model-row { display: flex; gap: 8px; align-items: center; margin-bottom: 8px; }
                .model-row .form-input { flex: 1; margin: 0; }
                .model-help { font-size: 11px; color: #777; margin-top: -8px; margin-bottom: 12px; }
                .divider { border-top: 1px solid #E5E7EB; margin: 16px 0; padding-top: 12px; }
                .checkbox-label { display: flex; align-items: center; cursor: pointer; font-size: 13px; color: #374151; }
                .checkbox-label input { width: 16px; height: 16px; margin-right: 8px; accent-color: #2563EB; }
                @keyframes breathe { 0%, 100% { opacity: 0.6; } 50% { opacity: 1; } }
                @keyframes blink { 0%, 100% { opacity: 0.5; transform: scale(0.9); } 50% { opacity: 1; transform: scale(1.1); } }
            `;
            this.#shadow.appendChild(style);

            this.#indicator = document.createElement('div');
            this.#indicator.className = 'indicator';
            this.#indicator.onclick = onOpenSettings;
            this.#shadow.appendChild(this.#indicator);

            this.updateStatus('idle', 'AI 验证码待机中');
        }

        updateStatus(status, text) {
            this.#indicator.className = `indicator status-${status}`;
            this.#indicator.setAttribute('data-title', text);
        }

        showToast(msg) {
            let toast = this.#shadow.querySelector('.toast');
            if (!toast) {
                toast = document.createElement('div');
                toast.className = 'toast';
                this.#shadow.appendChild(toast);
            }
            toast.textContent = msg;
            toast.classList.add('show');
            clearTimeout(this.#toastTimer);
            this.#toastTimer = setTimeout(() => toast.classList.remove('show'), 3000);
        }

        renderSettingsModal(onSave) {
            let modal = this.#shadow.querySelector('.modal-backdrop');
            if (!modal) {
                modal = document.createElement('div');
                modal.className = 'modal-backdrop';
                modal.innerHTML = `
                    <div class="modal-card">
                        <h3 style="margin:0 0 16px 0; color:#111827; font-size:18px">配置 AI 验证码</h3>
                        <div class="form-group">
                            <label class="form-label">服务商</label>
                            <select id="p" class="form-input" style="background:white">
                                <option value="openai">OpenAI / 兼容</option>
                                <option value="gemini">Google Gemini</option>
                                <option value="qwen">通义千问</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label">API 地址 (Base URL)</label>
                            <input id="u" class="form-input" placeholder="https://api.openai.com/v1/chat/completions">
                        </div>
                        <div class="form-group">
                            <label class="form-label">API Key</label>
                            <input id="k" type="password" class="form-input" placeholder="sk-...">
                        </div>
                        <div class="form-group">
                            <label class="form-label">模型名称 (Model)</label>
                            <div class="model-row">
                                <select id="mlist" class="form-input" style="background:white">
                                    <option value="">接口加载后可选</option>
                                </select>
                                <button id="fetchBtn" class="btn btn-secondary btn-small" type="button">拉取</button>
                            </div>
                            <input id="m" class="form-input" placeholder="例如：gpt-4o-mini">
                            <div class="model-help">点击"拉取"从 API 获取可用模型列表，或直接手动输入</div>
                        </div>
                        <div class="form-group">
                            <label class="form-label">识别提示词 (Prompt)</label>
                            <textarea id="tp" class="form-textarea" rows="2" placeholder="描述如何识别验证码，只输出结果"></textarea>
                        </div>
                        <div class="divider">
                            <label class="checkbox-label">
                                <input id="mm" type="checkbox">
                                启用手动模式 (显示"点击填充"按钮，而非自动识别)
                            </label>
                        </div>
                        <div style="text-align:right; margin-top:16px">
                            <button id="c" class="btn btn-secondary">取消</button>
                            <button id="s" class="btn btn-primary">保存配置</button>
                        </div>
                    </div>`;
                this.#shadow.appendChild(modal);

                const $ = s => modal.querySelector(s);
                const loadProvider = p => {
                    const conf = Config.get();
                    const c = conf[p];
                    $('#u').value = c.baseUrl || Config.DEFAULTS[p].baseUrl;
                    $('#k').value = c.apiKey || '';
                    $('#m').value = c.model || Config.DEFAULTS[p].model;
                    $('#tp').value = c.textPrompt || Config.DEFAULTS[p].textPrompt;
                    $('#mlist').innerHTML = '<option value="">接口加载后可选</option>';
                };
                const renderModelOptions = list => {
                    const sel = $('#mlist');
                    sel.innerHTML = '<option value="">接口加载后可选</option>';
                    list.forEach(m => {
                        const opt = document.createElement('option');
                        opt.value = m;
                        opt.textContent = m;
                        if (m === $('#m').value) opt.selected = true;
                        sel.appendChild(opt);
                    });
                };
                const fetchModels = async () => {
                    const btn = $('#fetchBtn');
                    const sel = $('#mlist');
                    btn.disabled = true;
                    btn.textContent = '加载中';
                    sel.innerHTML = '<option value="">加载中...</option>';
                    try {
                        const p = $('#p').value;
                        const list = await ModelService.list(p, { baseUrl: $('#u').value, apiKey: $('#k').value });
                        renderModelOptions(list);
                    } catch (err) {
                        alert(`拉取模型失败：${err.message}`);
                        sel.innerHTML = '<option value="">接口加载后可选</option>';
                    } finally {
                        btn.disabled = false;
                        btn.textContent = '拉取';
                    }
                };

                $('#p').onchange = e => loadProvider(e.target.value);
                $('#fetchBtn').onclick = fetchModels;
                $('#mlist').onchange = e => { if (e.target.value) $('#m').value = e.target.value; };
                $('#c').onclick = () => modal.classList.remove('open');
                $('#s').onclick = () => {
                    const p = $('#p').value;
                    onSave({
                        provider: p,
                        manualMode: $('#mm').checked,
                        [p]: {
                            baseUrl: $('#u').value,
                            apiKey: $('#k').value,
                            model: $('#m').value,
                            textPrompt: $('#tp').value
                        }
                    });
                    modal.classList.remove('open');
                };
            }

            const conf = Config.get();
            const p = conf.provider;
            const $ = s => modal.querySelector(s);
            $('#p').value = p;
            $('#u').value = conf[p].baseUrl || Config.DEFAULTS[p].baseUrl;
            $('#k').value = conf[p].apiKey || '';
            $('#m').value = conf[p].model || Config.DEFAULTS[p].model;
            $('#tp').value = conf[p].textPrompt || Config.DEFAULTS[p].textPrompt;
            $('#mm').checked = !!conf.manualMode;
            $('#mlist').innerHTML = '<option value="">接口加载后可选</option>';
            modal.classList.add('open');
        }
    }

    class AutoController {
        #uiManager;
        #processed = new WeakSet();
        #inputState = new WeakMap();
        #imgMeta = new WeakMap();
        #pendingResult = null;

        constructor() {
            Config.load();
            this.#uiManager = new UiManager(() => this.#openSettings());
            this.#checkApiKey();
            GM_registerMenuCommand('⚙️ 验证码设置', () => this.#openSettings());
            this.#injectStyles();
            setInterval(() => this.#scan(), 1500);
            this.#initAltClick();
            this.#initPendingFill();
        }

        #checkApiKey() {
            const conf = Config.get();
            if (!conf[conf.provider]?.apiKey) {
                this.#uiManager.updateStatus('error', '未配置 Key (点击配置)');
            }
        }

        #openSettings() {
            this.#uiManager.renderSettingsModal(newConfig => {
                Config.save(newConfig);
                this.#checkApiKey();
                this.#uiManager.showToast('设置已保存');
                const conf = Config.get();
                if (conf[conf.provider]?.apiKey) {
                    this.#uiManager.updateStatus('idle', 'AI 待机中');
                }
            });
        }

        #injectStyles() {
            const style = document.createElement('style');
            style.textContent = `
                .ai-captcha-fill-btn {
                    position: absolute;
                    z-index: 9999;
                    background-color: #2563EB;
                    color: white;
                    border: none;
                    border-radius: 4px;
                    padding: 2px 6px;
                    font-size: 12px;
                    cursor: pointer;
                    opacity: 0.8;
                    transition: opacity 0.2s, background-color 0.2s;
                    box-shadow: 0 1px 3px rgba(0,0,0,0.2);
                    white-space: nowrap;
                }
                .ai-captcha-fill-btn:hover {
                    opacity: 1;
                    background-color: #1D4ED8;
                }
            `;
            document.head.appendChild(style);
        }

        #initAltClick() {
            document.addEventListener('click', e => {
                if (!e.altKey) return;
                const img = e.target?.closest?.('img');
                if (!img) return;

                e.preventDefault();
                e.stopImmediatePropagation();

                const input = this.#findInput(img);
                if (input) {
                    this.#process(img, true, input);
                } else {
                    this.#processWithPending(img);
                }
            }, true);
        }

        #initPendingFill() {
            document.addEventListener('click', e => {
                if (!this.#pendingResult) return;
                const input = e.target?.closest?.('input');
                if (!input) return;

                const type = (input.type || 'text').toLowerCase();
                if (SECURITY.TYPE_BLACKLIST.includes(type)) return;
                if (input.disabled || input.readOnly) return;

                e.preventDefault();
                e.stopImmediatePropagation();

                input.value = this.#pendingResult;
                input.dispatchEvent(new Event('input', { bubbles: true }));
                input.dispatchEvent(new Event('change', { bubbles: true }));
                this.#inputState.set(input, { lastCode: this.#pendingResult });

                input.style.outline = '3px solid #10B981';
                setTimeout(() => input.style.outline = '', 2000);

                this.#uiManager.showToast(`已填入: ${this.#pendingResult}`);
                this.#pendingResult = null;
            }, true);
        }

        async #processWithPending(img) {
            this.#uiManager.updateStatus('processing', 'AI 识别中...');
            const originStyle = img.style.cssText;
            img.style.outline = '3px solid #3B82F6';
            img.style.transition = '0.2s';

            try {
                const base64 = await this.#captureBase64(img);
                const res = await AI.solve(base64);
                const clean = this.#normalizeResult(res);

                this.#pendingResult = clean;
                img.style.outline = '3px solid #10B981';
                this.#uiManager.showToast(`识别完成: ${clean} (点击输入框填入)`);

                setTimeout(() => {
                    if (this.#pendingResult === clean) {
                        this.#pendingResult = null;
                        this.#uiManager.showToast('填充已取消');
                    }
                }, 30000);
            } catch (err) {
                console.error(err);
                img.style.outline = '3px solid #EF4444';
                this.#uiManager.showToast(`识别失败: ${err.message}`);
            } finally {
                setTimeout(() => {
                    img.style.cssText = originStyle;
                    this.#uiManager.updateStatus('idle', 'AI 待机中');
                }, 2000);
            }
        }

        #scan() {
            const conf = Config.get();
            if (!conf[conf.provider]?.apiKey) return;

            const selectors = conf.selectors.join(',');
            const images = document.querySelectorAll(selectors);

            images.forEach(img => {
                this.#observeImage(img);
                if (this.#processed.has(img) || img.offsetParent === null) return;

                const rect = img.getBoundingClientRect();
                if (rect.width < 30 || rect.height < 10) return;

                const input = this.#findInput(img);
                if (!input) return;

                if (conf.manualMode) {
                    if (!img.dataset.aicaptchaButtonAdded) {
                        this.#createFillButton(img, input);
                        img.dataset.aicaptchaButtonAdded = 'true';
                    }
                } else {
                    if (!input.value.trim()) {
                        this.#process(img, false, input);
                    }
                }
            });
        }

        #findInput(img) {
            let best = { input: null, score: -1 };
            const attrCache = new Map();
            let candidates = [];
            let parent = img.parentElement;

            for (let i = 0; i < 5 && parent; i++) {
                parent.querySelectorAll('input').forEach(input => {
                    const type = (input.type || 'text').toLowerCase();
                    if (SECURITY.TYPE_BLACKLIST.includes(type)) return;
                    if (input.disabled || input.readOnly) return;
                    if (!input.offsetParent) return;
                    if (!candidates.includes(input)) candidates.push(input);
                });
                parent = parent.parentElement;
            }

            const infos = candidates.map(input => {
                const attrs = attrCache.get(input) || `${input.id} ${input.name} ${input.className} ${input.placeholder || ''}`.toLowerCase();
                attrCache.set(input, attrs);
                return {
                    input,
                    attrs,
                    whiteIndex: SECURITY.KEYWORD_WHITELIST.findIndex(k => attrs.includes(k)),
                    hasBlack: SECURITY.KEYWORD_BLACKLIST.some(k => attrs.includes(k))
                };
            });

            infos.forEach(info => {
                if (info.whiteIndex !== -1) {
                    const score = SECURITY.KEYWORD_WHITELIST.length - info.whiteIndex;
                    if (score > best.score) best = { input: info.input, score };
                    return;
                }
                if (info.hasBlack) return;
            });

            if (best.input) return best.input;

            const safeFallback = infos.filter(i => !i.hasBlack).map(i => i.input);
            if (safeFallback.length === 1) return safeFallback[0];
            return null;
        }

        async #process(img, force = false, inputEl = null, button = null) {
            if (this.#processed.has(img) && !force) return;
            this.#processed.add(img);

            const feedbackEl = inputEl || img;

            if (inputEl && !force && inputEl.value.trim()) {
                this.#processed.delete(img);
                return;
            }

            this.#uiManager.updateStatus('processing', 'AI 识别中...');
            const originStyle = feedbackEl.style.cssText;
            feedbackEl.style.outline = '3px solid #3B82F6';
            feedbackEl.style.transition = '0.2s';
            const originalPlaceholder = inputEl?.placeholder;
            if (inputEl) inputEl.placeholder = 'AI 识别中...';
            if (button) button.textContent = '识别中...';

            try {
                const base64 = await this.#captureBase64(img);
                const res = await AI.solve(base64);
                const clean = this.#normalizeResult(res);

                if (inputEl) {
                    inputEl.value = clean;
                    inputEl.dispatchEvent(new Event('input', { bubbles: true }));
                    inputEl.dispatchEvent(new Event('change', { bubbles: true }));
                    this.#inputState.set(inputEl, { lastCode: clean });
                    this.#uiManager.showToast(`已填入: ${clean}`);
                } else if (force) {
                    console.log('[AI OCR][Alt+Click]', clean);
                    this.#uiManager.showToast(`识别结果: ${clean}`);
                }

                feedbackEl.style.outline = '3px solid #10B981';
            } catch (err) {
                console.error(err);
                feedbackEl.style.outline = '3px solid #EF4444';
                this.#uiManager.showToast(`识别失败: ${err.message}`);
                this.#processed.delete(img);
            } finally {
                setTimeout(() => {
                    feedbackEl.style.cssText = originStyle;
                    if (inputEl && originalPlaceholder) inputEl.placeholder = originalPlaceholder;
                    if (button) button.textContent = '点击填充';
                    this.#uiManager.updateStatus('idle', 'AI 待机中');
                }, 2000);
            }
        }

        #observeImage(img) {
            if (this.#imgMeta.has(img)) return;
            const reset = () => this.#handleRefresh(img);

            img.addEventListener('load', reset, { passive: true });

            const obs = new MutationObserver(muts => {
                if (!img.isConnected) {
                    obs.disconnect();
                    this.#imgMeta.delete(img);
                    return;
                }
                for (const m of muts) {
                    if (m.type === 'attributes' && m.attributeName === 'src') {
                        reset();
                        break;
                    }
                }
            });
            obs.observe(img, { attributes: true, attributeFilter: ['src'] });

            this.#imgMeta.set(img, { observer: obs });
        }

        #handleRefresh(img) {
            this.#processed.delete(img);
            const input = this.#findInput(img);
            if (!input) return;
            this.#clearIfAIFilled(input);
        }

        #clearIfAIFilled(input) {
            const state = this.#inputState.get(input);
            if (!state || !state.lastCode) return;
            if (input.value === state.lastCode) {
                input.value = '';
                input.dispatchEvent(new Event('input', { bubbles: true }));
                input.dispatchEvent(new Event('change', { bubbles: true }));
            }
        }

        async #captureBase64(img) {
            if (!img.complete || !img.naturalWidth) await this.#waitForImage(img);
            const w = img.naturalWidth || img.width;
            const h = img.naturalHeight || img.height;
            if (!w || !h) throw new Error('Invalid image size');

            const dpr = window.devicePixelRatio || 1;
            const cvs = document.createElement('canvas');
            cvs.width = w * dpr;
            cvs.height = h * dpr;

            const ctx = cvs.getContext('2d');
            if (!ctx) throw new Error('No 2D context');

            ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
            ctx.imageSmoothingEnabled = false;
            ctx.drawImage(img, 0, 0, w, h);
            return cvs.toDataURL('image/png');
        }

        #normalizeResult(raw) {
            const compact = (raw || '').replace(/\s+/g, '');
            if (!compact) throw new Error('Empty OCR result');
            if (!/^[A-Za-z0-9+\-*/=]+$/.test(compact)) throw new Error('Invalid captcha result');

            let cleaned = compact.replace(/=$/, '');
            if (!cleaned) throw new Error('Invalid captcha result');

            if (/^\d+[+\-*/]\d+/.test(cleaned)) {
                try {
                    const val = Function(`return ${cleaned}`)();
                    if (Number.isFinite(val)) cleaned = String(val);
                } catch {}
            }
            return cleaned;
        }

        #waitForImage(img) {
            if (img.complete && img.naturalWidth) return Promise.resolve();
            return new Promise((resolve, reject) => {
                const cleanup = () => {
                    img.removeEventListener('load', onLoad);
                    img.removeEventListener('error', onError);
                };
                const onLoad = () => { cleanup(); resolve(); };
                const onError = () => { cleanup(); reject(new Error('Image load error')); };
                img.addEventListener('load', onLoad, { once: true });
                img.addEventListener('error', onError, { once: true });
            });
        }

        #createFillButton(img, input) {
            const button = document.createElement('button');
            button.textContent = '点击填充';
            button.className = 'ai-captcha-fill-btn';
            button.type = 'button';

            button.onclick = e => {
                e.preventDefault();
                this.#process(img, true, input, button);
            };

            const container = img.parentElement;
            if (window.getComputedStyle(container).position === 'static') {
                container.style.position = 'relative';
            }
            container.appendChild(button);

            const imgRect = img.getBoundingClientRect();
            const containerRect = container.getBoundingClientRect();
            let top = img.offsetTop;
            let left = img.offsetLeft + img.offsetWidth + 5;

            if (left + 70 > container.offsetWidth) {
                left = img.offsetLeft;
                top = img.offsetTop + img.offsetHeight + 5;
            }
            button.style.top = `${top}px`;
            button.style.left = `${left}px`;
        }
    }

    new AutoController();
})();
