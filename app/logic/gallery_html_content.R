# app/logic/gallery_html_content.R

# Import R packages / functions into module
box::use(
    shiny[HTML],
)

#' @export
gallery_content <- function() {

  HTML(
    '<p>IN DEVELOPMENT</p>'
    # <img src="./static/img/Mapmixture1.png">
    # '
    # <h4 class="text-primary">Examples</h4>
    # <div id="myCarousel" class="carousel slide" data-bs-ride="carousel">
    #     <div class="carousel-inner">
    #         <div class="carousel-item active">
    #         <div class="d-flex align-items-center justify-content-center">
    #             <img src="./static/img/Mapmixture1.png" alt="Image 1">
    #         </div>
    #         </div>
    #         <div class="carousel-item">
    #         <div class="d-flex align-items-center justify-content-center">
    #             <img src="./static/img/Mapmixture1.png" alt="Image 2">
    #         </div>
    #         </div>
    #         <div class="carousel-item">
    #         <div class="d-flex align-items-center justify-content-center">
    #             <img src="./static/img/Mapmixture1.png" alt="Image 3">
    #         </div>
    #         </div>
    #     </div>
    # </div>
    # '
    )
}
