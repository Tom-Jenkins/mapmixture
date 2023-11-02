#' Gallery Tab Content
#'
#' @noRd
#' @description Return HTML string containing content for the Gallery tabPanel
#' @importFrom htmltools HTML

gallery_content <- function() {

  HTML(
    '
    <div id="gallery" class="carousel slide carousel-dark" data-interval="false">

      <div class="carousel-inner">
        <div class="carousel-item active">
          <img class="mx-auto d-block" src="./www/img/Mapmixture1.jpeg" alt="Example1" height="100%">
        </div>
        <div class="carousel-item">
          <img class="mx-auto d-block" src="./www/img/Mapmixture2.jpeg" alt="Example2" height="100%">
        </div>
        <div class="carousel-item">
          <img class="mx-auto d-block" src="./www/img/Mapmixture3.jpeg" alt="Example3" height="100%">
        </div>
        <div class="carousel-item">
          <img class="mx-auto d-block" src="./www/img/Mapmixture4.jpeg" alt="Example4" height="100%">
        </div>
        <div class="carousel-item">
          <img class="mx-auto d-block" src="./www/img/Mapmixture5.jpeg" alt="Example5" height="100%">
        </div>
      </div>

      <button class="carousel-control-prev" type="button" data-bs-target="#gallery" data-bs-slide="prev">
        <span class="carousel-control-prev-icon"></span>
      </button>

      <button class="carousel-control-next" type="button" data-bs-target="#gallery" data-bs-slide="next">
        <span class="carousel-control-next-icon"></span>
      </button>

    </div>
  ')
}
