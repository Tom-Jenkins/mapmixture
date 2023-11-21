# Shiny app successfully loads data and outputs map

    "<a id=\"main_plot-download_bttn\" class=\"btn btn-default shiny-download-link btn-success shiny-bound-output\" href=\"\" target=\"_blank\" download=\"\" aria-live=\"polite\">\n          <i class=\"fas fa-download\" role=\"presentation\" aria-label=\"download icon\"><\/i>\n           Download\n        <\/a>"

# Invalid file uploads render feedback messages to UI

    "<p id=\"admixture-error-message\" class=\"p-1 text-warning fw-bold error-message\">Empty cell or NA in column 1. Ensure all cells have a site label.<\/p>"

---

    "<p id=\"admixture-error-message\" class=\"p-1 text-warning fw-bold error-message\">Empty cell or NA in column 2. Ensure all cells have an individual label.<\/p>"

---

    "<p id=\"admixture-error-message\" class=\"p-1 text-warning fw-bold error-message\">Empty cell or NA in column 3. Ensure all cells in cluster column have an integer or decimal from 0-1.<\/p>"

---

    "<p id=\"admixture-error-message\" class=\"p-1 text-warning fw-bold error-message\">Empty cell or NA in column 3, 4. Ensure all cells in cluster column have an integer or decimal from 0-1.<\/p>"

---

    "<p id=\"admixture-error-message\" class=\"p-1 text-warning fw-bold error-message\">Incorrect data type in column 3. Ensure all cells in cluster column have an integer or decimal from 0-1.<\/p>"

---

    "<p id=\"admixture-error-message\" class=\"p-1 text-warning fw-bold error-message\">Incorrect data type in column 3, 4. Ensure all cells in cluster column have an integer or decimal from 0-1.<\/p>"

---

    "<p id=\"coords-error-message\" class=\"p-1 text-warning fw-bold error-message\">Invalid file. Please upload a valid comma-separated values or tab-separated values file.<\/p>"

---

    "<p id=\"coords-error-message\" class=\"p-1 text-warning fw-bold error-message\">Site IDs do not match. Ensure site IDs are present and match in both admixture and coordinates files.<\/p>"

---

    "<p id=\"coords-error-message\" class=\"p-1 text-warning fw-bold error-message\">Empty cell or NA in column 1. Ensure all cells have a site label.<\/p>"

---

    "<p id=\"coords-error-message\" class=\"p-1 text-warning fw-bold error-message\">Empty cell or NA in column 2. Ensure all cells have a latitude decimal.<\/p>"

---

    "<p id=\"coords-error-message\" class=\"p-1 text-warning fw-bold error-message\">Empty cell or NA in column 3. Ensure all cells have a longitude decimal.<\/p>"

---

    "<p id=\"coords-error-message\" class=\"p-1 text-warning fw-bold error-message\">Incorrect data type in column 2. Ensure all cells have a latitude decimal.<\/p>"

---

    "<p id=\"coords-error-message\" class=\"p-1 text-warning fw-bold error-message\">Incorrect data type in column 3. Ensure all cells have a longitude decimal.<\/p>"

# Information modals render when button is clicked

    "<div id=\"shiny-modal-wrapper\"><div class=\"modal fade show\" id=\"shiny-modal\" tabindex=\"-1\" aria-modal=\"true\" role=\"dialog\" style=\"display: block;\">\n  <div class=\"modal-dialog modal-lg\">\n    <div class=\"modal-content\">\n      <div class=\"modal-header\">\n        <h4 class=\"modal-title\">\n          <strong style=\"font-size: larger;\">Admixture File Format<\/strong>\n        <\/h4>\n      <\/div>\n      <div class=\"modal-body\">\n        \n      <table class=\"table table-striped\">\n        <thead>\n          <tr class=\"table-success\">\n            <th scope=\"col\">Site<\/th>\n            <th scope=\"col\">Individual<\/th>\n            <th scope=\"col\">Cluster 1<\/th>\n            <th scope=\"col\">Cluster 2<\/th>\n            <th scope=\"col\">Cluster 3<\/th>\n            <th scope=\"col\">Cluster ...<\/th>\n          <\/tr>\n        <\/thead>\n        <tbody>\n          <tr>\n              <td>SiteA<\/td>\n              <td>Sample1<\/td>\n              <td>0.50<\/td>\n              <td>0.25<\/td>\n              <td>0.25<\/td>\n              <td>...<\/td>\n          <\/tr>\n          <tr>\n              <td>SiteA<\/td>\n              <td>Sample2<\/td>\n              <td>0.40<\/td>\n              <td>0.35<\/td>\n              <td>0.25<\/td>\n              <td>...<\/td>\n          <\/tr>\n          <tr>\n              <td>SiteB<\/td>\n              <td>Sample3<\/td>\n              <td>0.05<\/td>\n              <td>0.05<\/td>\n              <td>0.90<\/td>\n              <td>...<\/td>\n          <\/tr>\n          <tr>\n              <td>SiteB<\/td>\n              <td>Sample4<\/td>\n              <td>0.00<\/td>\n              <td>0.05<\/td>\n              <td>0.95<\/td>\n              <td>...<\/td>\n          <\/tr>\n          <tr>\n              <td>...<\/td>\n              <td>...<\/td>\n              <td>...<\/td>\n              <td>...<\/td>\n              <td>...<\/td>\n              <td>...<\/td>\n          <\/tr>\n        <\/tbody>\n      <\/table>\n      <span class=\"d-block p-2 bg-warning text-white\">The site IDs in the <span class=\"fw-bold\">Site<\/span> column must match those in the <span class=\"fw-bold\">Site<\/span> column from the <span class=\"fw-bold\">Coordinates<\/span> File.<\/span>\n      \n        <br>\n        <div class=\"text-center\"><button type=\"button\" class=\"btn btn-success modal-close-bttn\" data-dismiss=\"modal\" data-bs-dismiss=\"modal\">Close<\/button><\/div>\n      <\/div>\n    <\/div>\n  <\/div>\n  <script>if (window.bootstrap && !window.bootstrap.Modal.VERSION.match(/^4\\./)) {\n         var modal = new bootstrap.Modal(document.getElementById('shiny-modal'));\n         modal.show();\n      } else {\n         $('#shiny-modal').modal().focus();\n      }<\/script>\n<\/div><\/div>"

---

    "<div id=\"shiny-modal-wrapper\"><div class=\"modal fade show\" id=\"shiny-modal\" tabindex=\"-1\" aria-modal=\"true\" role=\"dialog\" style=\"display: block;\">\n  <div class=\"modal-dialog modal-lg\">\n    <div class=\"modal-content\">\n      <div class=\"modal-header\">\n        <h4 class=\"modal-title\">\n          <strong style=\"font-size: larger;\">Coordinates File Format<\/strong>\n        <\/h4>\n      <\/div>\n      <div class=\"modal-body\">\n        \n    <table class=\"table table-striped\">\n        <thead>\n            <tr class=\"table-success\">\n                <th scope=\"col\">Site<\/th>\n                <th scope=\"col\">Lat<\/th>\n                <th scope=\"col\">Lon<\/th>\n            <\/tr>\n        <\/thead>\n        <tbody>\n            <tr>\n                <td>SiteA<\/td>\n                <td>52.94<\/td>\n                <td>1.31<\/td>\n            <\/tr>\n            <tr>\n                <td>SiteB<\/td>\n                <td>58.42<\/td>\n                <td>8.76<\/td>\n            <\/tr>\n            <tr>\n                <td>SiteC<\/td>\n                <td>46.13<\/td>\n                <td>-1.25<\/td>\n            <\/tr>\n            <tr>\n                <td>SiteD<\/td>\n                <td>-33.40<\/td>\n                <td>-70.05<\/td>\n            <\/tr>\n            <tr>\n                <td>...<\/td>\n                <td>...<\/td>\n                <td>...<\/td>\n            <\/tr>\n        <\/tbody>\n    <\/table>\n    <span class=\"d-block p-2 bg-warning text-white\">\n      The site IDs in the <span class=\"fw-bold\">Site<\/span> column must match those in the <span class=\"fw-bold\">Site<\/span> column from the <span class=\"fw-bold\">Admixture<\/span> File.\n    <\/span>\n    \n        <br>\n        <div class=\"text-center\"><button type=\"button\" class=\"btn btn-success modal-close-bttn\" data-dismiss=\"modal\" data-bs-dismiss=\"modal\">Close<\/button><\/div>\n      <\/div>\n    <\/div>\n  <\/div>\n  <script>if (window.bootstrap && !window.bootstrap.Modal.VERSION.match(/^4\\./)) {\n         var modal = new bootstrap.Modal(document.getElementById('shiny-modal'));\n         modal.show();\n      } else {\n         $('#shiny-modal').modal().focus();\n      }<\/script>\n<\/div><\/div>"

