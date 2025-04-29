'use strict';

moj.Modules.fileUploadTranslations = {
    selectors: {
        buttonContainer: '.govuk-file-upload-button',
        chooseButton: '.govuk-button--secondary',
        dropInstruction: '.govuk-file-upload-button__instruction',
        statusText: '.govuk-file-upload-button__status'
    },

    translationsFor(lang) {
        return {
            chooseFilesButton: moj.t(`moj.Modules.fileUploaderTranslations.${lang}.chooseFilesButton`),
            dropInstruction: moj.t(`moj.Modules.fileUploaderTranslations.${lang}.dropInstruction`),
            noFileChosen: moj.t(`moj.Modules.fileUploaderTranslations.${lang}.noFileChosen`),
            multipleFilesChosen: {
                one: moj.t(`moj.Modules.fileUploaderTranslations.${lang}.multipleFilesChosen.one`),
                other: moj.t(`moj.Modules.fileUploaderTranslations.${lang}.multipleFilesChosen.other`)
            },
            enteredDropZone: moj.t(`moj.Modules.fileUploaderTranslations.${lang}.enteredDropZone`),
            leftDropZone: moj.t(`moj.Modules.fileUploaderTranslations.${lang}.leftDropZone`)
        };
    },

    init() {
        const lang = window.location.pathname.includes('/cy') ? 'cy' : 'en';
        const t = this.translationsFor(lang);

        this.overrideGovukFileUpload(t);
        this.updateFileUploadUI(t);
    },

    overrideGovukFileUpload(t) {
        const FileUpload = window.GOVUKFrontend.FileUpload;

        if (typeof FileUpload === 'function') {
            window.GOVUKFrontend.FileUpload = class extends FileUpload {
                constructor($root, config = {}) {
                    super($root, { ...config, i18n: t });
                }
            };
        }
    },

    updateFileUploadUI(t) {
        const { buttonContainer, chooseButton, dropInstruction, statusText } = this.selectors;

        const $container = document.querySelector(buttonContainer);
        if (!$container) return;

        const $chooseBtn = $container.querySelector(chooseButton);
        const $instruction = $container.querySelector(dropInstruction);
        const $status = $container.querySelector(statusText);

        if ($chooseBtn) $chooseBtn.innerText = t.chooseFilesButton;
        if ($instruction) $instruction.innerText = t.dropInstruction;
        if ($status) $status.innerText = t.noFileChosen;
    }
};
