// ---------- //
// Dynamically adjust height of sidebarPanel, options tabPanel, and the mainPanel depending on screen size
// ---------- //

// Calculate maximum height of the container where the map will render based on the users screen height
const navbarHeight = document.querySelector(".custom-navbar").offsetHeight;
const navbarHeightMargin = parseInt(window.getComputedStyle(document.querySelector(".custom-navbar")).getPropertyValue("margin-bottom"));
const navtabsHeight = document.querySelector(".nav-tabs").offsetHeight;
const sidebarNonParamContainerHeight = document.querySelector(".sidebar-nonparam-container").offsetHeight;
const sidebarPillsHeight = document.getElementById("options-pills-container").offsetHeight;
const sidebarContainerHeight = window.innerHeight - navbarHeight - navbarHeightMargin - 20;
const sidebarOptionsContainerHeight = sidebarContainerHeight - sidebarNonParamContainerHeight - sidebarPillsHeight - 25;
const mainContainerHeight = window.innerHeight - navbarHeight - navbarHeightMargin - navtabsHeight - 20;

// Then set the height of sidebarPanel and MainPanel containers
document.querySelector(".sidebar-container").style.height = `${sidebarContainerHeight}px`;
document.querySelector(".parameter-options-container").style.height = `${sidebarOptionsContainerHeight}px`;
document.getElementById("main_plot-admixture_map").style.height = `${mainContainerHeight}px`;
document.getElementById("bar_plot-admixture_barplot").style.height = `${mainContainerHeight}px`;
document.querySelectorAll(".carousel-item").forEach(function(element) {
  element.style.height = `${mainContainerHeight - 5}px`;
});

// Do these calculations and change the height of the container each time the window is resized
// For example, when the user drags the browser from a laptop screen to a desktop screen (or vice versa)
window.addEventListener("resize", () => {
  document.getElementById("main_plot-admixture_map").textContent = "";
  document.getElementById("bar_plot-admixture_barplot").textContent = "";

  const sidebarContainerHeight = window.innerHeight - navbarHeight - navbarHeightMargin - 20;
  const sidebarNonParamContainerHeight = document.querySelector(".sidebar-nonparam-container").offsetHeight;
  const sidebarPillsHeight = document.getElementById("options-pills-container").offsetHeight;
  const sidebarOptionsContainerHeight = sidebarContainerHeight - sidebarNonParamContainerHeight - sidebarPillsHeight - 25;

  document.querySelector(".sidebar-container").style.height = `${sidebarContainerHeight}px`;
  document.querySelector(".parameter-options-container").style.height = `${sidebarOptionsContainerHeight}px`;
  document.getElementById("main_plot-admixture_map").style.height = `${window.innerHeight - navbarHeight - navbarHeightMargin - navtabsHeight - 20}px`;
  document.getElementById("bar_plot-admixture_barplot").style.height = `${window.innerHeight - navbarHeight - navbarHeightMargin - navtabsHeight - 25}px`;
  document.querySelectorAll(".carousel-item").forEach(function(element) {
    element.style.height = `${window.innerHeight - navbarHeight - navbarHeightMargin - navtabsHeight - 25}px`;
  });
});


// ---------- //
// Function to activate feedback success when file input is valid
// ---------- //
function renderFeedbackSuccess (file) {

    // Select elements from DOM
    const admixtureInput = document.querySelector("#file_upload-admixture_file-label + div.input-group > input");
    const coordsInput = document.querySelector("#file_upload-coords_file-label + div.input-group > input");
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


// ---------- //
// Function to activate feedback error when file input is invalid
// ---------- //
function renderFeedbackWarning (file, text) {

    // Select elements from DOM
    const admixtureInput = document.querySelector("#file_upload-admixture_file-label + div.input-group > input");
    const coordsInput = document.querySelector("#file_upload-coords_file-label + div.input-group > input");
    const admixtureIcon = document.getElementById("admixture-warning");
    const coordsIcon = document.getElementById("coords-warning");
    const admixtureContainer = document.querySelector("#file_upload-admixture_file-label + div.input-group");
    const coordsContainer = document.querySelector("#file_upload-coords_file-label + div.input-group");

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


// ---------- //
// Function to clear plotOutput content when Plot Data button is (re)clicked
// ---------- //
function clearPlotOutput (plot) {

  // Do this for map
  if (plot == "map") {
    document.getElementById("main_plot-admixture_map").textContent = "";
    document.getElementById("main_plot-dropdown_download_bttn").classList.add("hidden");
    document.getElementById("map_download_bttn_display").classList.add("hidden");
  }

  // Do this for bar
  if (plot == "bar") {
    document.getElementById("bar_plot-admixture_barplot").textContent = "";
    document.getElementById("bar_plot-dropdown_download_bttn").classList.add("hidden");
    document.getElementById("bar_download_bttn_display").classList.add("hidden");
  }
};
