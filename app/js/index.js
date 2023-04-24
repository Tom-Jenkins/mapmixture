// app/js/index.js

// Function to render file name when load sample data button is clicked
export function renderSampleData(dataType) {
    if (dataType === "admixture") {
        document.querySelector("div.sidebar-nonparam-container > div:nth-child(3) > div:nth-child(1) > div > div.input-group > input").value = "admix_sample.csv";
    }
    if (dataType === "coordinates") {
        document.querySelector("div.sidebar-nonparam-container > div:nth-child(5) > div:nth-child(1) > div > div.input-group > input").value = "coords_sample.csv";
    }
};

// Function to clear plotOutput content when Plot Data button is (re)clicked
export function clearPlotOutput () {
    document.getElementById("app-map_plot_module-admixture_map").textContent = "";
};







