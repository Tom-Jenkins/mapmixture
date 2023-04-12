# app/view/map_params_module.R

# Import R packages / functions into module
box::use(  
  shiny[moduleServer, NS, modalDialog, observeEvent, showModal, modalButton, HTML, strong, br, tagList, div, span, h3],
)


#' @export
ui <- function(id) {
  ns <- NS(id)
}


#' @export
server <- function(id, info_bttn_admixture, info_bttn_coords) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # Admixture table example
    table_admixture <- "
    <table class='table table-striped'>
        <thead>
            <tr class='table-success'>
                <th scope='col'>Site</th>
                <th scope='col'>Individual</th>
                <th scope='col'>Cluster 1</th>
                <th scope='col'>Cluster 2</th>
                <th scope='col'>Cluster 3</th>
                <th scope='col'>Cluster ...</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>SiteA</td>
                <td>Sample1</td>
                <td>0.50</td>
                <td>0.25</td>
                <td>0.25</td>
                <td>...</td>
            </tr>
            <tr>
                <td>SiteA</td>
                <td>Sample2</td>
                <td>0.40</td>
                <td>0.35</td>
                <td>0.25</td>
                <td>...</td>
            </tr>
            <tr>
                <td>SiteB</td>
                <td>Sample1</td>
                <td>0.05</td>
                <td>0.05</td>
                <td>0.90</td>
                <td>...</td>
            </tr>
            <tr>
                <td>SiteB</td>
                <td>Sample2</td>
                <td>0.00</td>
                <td>0.05</td>
                <td>0.95</td>
                <td>...</td>
            </tr>
            <tr>
                <td>...</td>
                <td>...</td>
                <td>...</td>
                <td>...</td>
                <td>...</td>
                <td>...</td>
            </tr>
        </tbody>
    </table>
    <br>
    <span class='d-inline p-2 bg-warning text-white'>The site IDs in the <span class='fw-bold'>Site</span> column must match those in the <span class='fw-bold'>Site</span> column from the Coordinates File.</span>
    <br>
    "

    # Coordinates table example
    coords_admixture <- "
    <table class='table table-striped'>
        <thead>
            <tr class='table-success'>
                <th scope='col'>Site</th>
                <th scope='col'>Lat</th>
                <th scope='col'>Lon</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>SiteA</td>
                <td>52.94</td>
                <td>1.31</td>
            </tr>
            <tr>
                <td>SiteB</td>
                <td>58.42</td>
                <td>8.76</td>
            </tr>
            <tr>
                <td>SiteC</td>
                <td>46.13</td>
                <td>-1.25</td>
            </tr>
            <tr>
                <td>SiteD</td>
                <td>-33.40</td>
                <td>-70.05</td>
            </tr>
            <tr>
                <td>...</td>
                <td>...</td>
                <td>...</td>
            </tr>
        </tbody>
    </table>
    <br>
    <span class='d-inline p-2 bg-warning text-white'>The site IDs in the <span class='fw-bold'>Site</span> column must match those in the <span class='fw-bold'>Site</span> column from the Admixture File.</span>
    <br>
    "

    # Function to build modal
    build_modal <- function(custom_title, html_content) {
      modalDialog(
        title = strong(custom_title, style = "font-size: larger;"),
        br(),
        HTML(html_content),
        br(),
        div(
          class = "text-center",
          HTML('<button type="button" class="btn btn-success modal-close-bttn" data-dismiss="modal" data-bs-dismiss="modal">Close</button>')
        ),
        footer = NULL, 
        easyClose = TRUE,
        size = "l"
      )
    }

    # Show modal on click of admixture info button
    observeEvent(info_bttn_admixture(), {
        showModal(build_modal("Admixture File Format", table_admixture))
    })

    # Show modal on click of coordinates info button
    observeEvent(info_bttn_coords(), {
        showModal(build_modal("Coordinates File Format", coords_admixture))
    })
    
  })
}



