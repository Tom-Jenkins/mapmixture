// app/js/index.js


// Function to activate feedback success when file input is valid
export function renderFeedbackSuccess (file) {

    // Select elements from DOM
    const admixtureInput = document.querySelector("#app-file_upload-admixture_file-label + div.input-group > input");
    const coordsInput = document.querySelector("#app-file_upload-coords_file-label + div.input-group > input");
    const admixtureIcon = document.getElementById("admixture-success");
    const coordsIcon = document.getElementById("coords-success");

    // Do this for admixture file success
    if (file === "admixture") {
        admixtureInput.style.borderColor = "var(--flatly-success)";
        admixtureInput.style.borderTopRightRadius = "5px";
        admixtureInput.style.borderBottomRightRadius = "5px";
        admixtureIcon.classList.remove("hidden");
    };

    // Do this for coords file success
    if (file === "coords") {
        coordsInput.style.borderColor = "var(--flatly-success)";
        coordsInput.style.borderTopRightRadius = "5px";
        coordsInput.style.borderBottomRightRadius = "5px";
        coordsIcon.classList.remove("hidden");
    };
};


// Function to activate feedback error when file input is invalid
export function renderFeedbackWarning (file, text) {

    // Select elements from DOM
    const admixtureInput = document.querySelector("#app-file_upload-admixture_file-label + div.input-group > input");
    const coordsInput = document.querySelector("#app-file_upload-coords_file-label + div.input-group > input");
    const admixtureIcon = document.getElementById("admixture-warning");
    const coordsIcon = document.getElementById("coords-warning");
    const admixtureContainer = document.querySelector("#app-file_upload-admixture_file-label + div.input-group");
    const coordsContainer = document.querySelector("#app-file_upload-coords_file-label + div.input-group");

    // Do this for admixture file warning
    if (file === "admixture") {
        admixtureInput.style.borderColor = "var(--flatly-warning)";
        admixtureInput.style.borderTopRightRadius = "5px";
        admixtureInput.style.borderBottomRightRadius = "5px";
        admixtureIcon.classList.remove("hidden");
        admixtureContainer.insertAdjacentHTML("afterend", `
            <p id="admixture-error-message" class="p-1 text-warning fw-bold error-message">${text}</p>`
        );
    };

    // Do this for coords file warning
    if (file === "coords") {
        coordsInput.style.borderColor = "var(--flatly-warning)";
        coordsInput.style.borderTopRightRadius = "5px";
        coordsInput.style.borderBottomRightRadius = "5px";
        coordsIcon.classList.remove("hidden");
        coordsContainer.insertAdjacentHTML("afterend", `
            <p id="coords-error-message" class="p-1 text-warning fw-bold error-message">${text}</p>`
        );
    };
};


// Function to clear plotOutput content when Plot Data button is (re)clicked
export function clearPlotOutput () {
    document.getElementById("app-map_plot_module-admixture_map").textContent = "";
};

