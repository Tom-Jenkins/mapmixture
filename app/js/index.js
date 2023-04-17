// app/js/index.js

// -------------------- //
// 
// INFORMATION MODALS
//
// -------------------- //

// Function to render file name when load sample data button is clicked
export function renderSampleData(dataType) {
    if (dataType === "admixture") {
        document.querySelector("body > div > div:nth-child(2) > div.col-sm-4 > form > div:nth-child(3) > div:nth-child(1) > div > div.input-group > input").value = "admix_sample.csv";
    }
    if (dataType === "coordinates") {
        document.querySelector("body > div > div:nth-child(2) > div.col-sm-4 > form > div:nth-child(5) > div:nth-child(1) > div > div.input-group > input").value = "coords_sample.csv";
    }
};





// Function to launch modal on click of admixture help button
export function admixtureHelp() {
    alert("Place help message here");
};

// Clear uploaded data on click of "Clear Uploaded Data" button
export function clearUploads() {

    // Remove text from file input
    document.querySelectorAll(".form-control").forEach(el => el.value = "");

    // Remove upload complete animation
    document.querySelectorAll(".shiny-file-input-progress").forEach(el => el.style.visibility = "hidden");
};





