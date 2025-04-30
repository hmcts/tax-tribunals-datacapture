'use strict';

moj.Modules.fileUploadTranslations = {
    selectors: {
        buttonContainer: '.govuk-file-upload-button',
        chooseButton: '.govuk-button--secondary',
        dropInstruction: '.govuk-file-upload-button__instruction',
        statusText: '.govuk-file-upload-button__status',
        fileInput: 'input[type="file"]'
    },

    translationsFor(lang) {
        const basePath = `moj.Modules.fileUploaderTranslations.${lang}`;
        return {
            chooseFilesButton: moj.t(`${basePath}.chooseFilesButton`),
            dropInstruction: moj.t(`${basePath}.dropInstruction`),
            noFileChosen: moj.t(`${basePath}.noFileChosen`),
            multipleFilesChosen: {
                one: moj.t(`${basePath}.multipleFilesChosen.one`),
                other: moj.t(`${basePath}.multipleFilesChosen.other`)
            }
        };
    },

    init() {
        const lang = window.location.pathname.includes('/cy') ? 'cy' : 'en';
        const t = this.translationsFor(lang);
        this.updateFileUploadUI(t);
        this.setupFileInputListener(t);
    },

    updateFileUploadUI(t) {
        const { buttonContainer, chooseButton, dropInstruction, statusText } = this.selectors;
        const $container = document.querySelector(buttonContainer);
        if (!$container) return;

        this.updateElementText($container.querySelector(chooseButton), t.chooseFilesButton);
        this.updateElementText($container.querySelector(dropInstruction), t.dropInstruction);
        this.updateElementText($container.querySelector(statusText), t.noFileChosen);
    },

    updateElementText(element, text) {
        if (element) element.innerText = text;
    },

    setupFileInputListener(t) {
        const fileInput = document.querySelector(this.selectors.fileInput);
        if (fileInput) {
            fileInput.addEventListener('change', (e) => {
                this.updateStatusText(t, e.target.files.length);
            });
        }
    },

    updateStatusText(t, fileCount) {
        const statusMessage = this.getStatusMessage(t, fileCount);
        if (statusMessage) {
            const $status = document.querySelector(this.selectors.statusText);
            this.updateElementText($status, statusMessage);
        }
    },

    getStatusMessage(t, fileCount) {
        if (fileCount === 0) {
            return t.noFileChosen;
        } else if (fileCount > 1) {
            return t.multipleFilesChosen.other.replace('%{count}', fileCount);
        }
    }
};
