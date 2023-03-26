// app/js/index.js

// Clear uploaded data on click of "Clear Uploaded Data" button
export function clearUploads() {

    // Remove text from file input
    document.querySelectorAll(".form-control").forEach(el => el.value = "");

    // Remove upload complete animation
    document.querySelectorAll(".shiny-file-input-progress").forEach(el => el.style.visibility = "hidden");
};





