# app/logic/gallery_html_content.R

# Import R packages / functions into module
box::use(
    shiny[HTML],
)

#' @export
gallery_content <- function() {

  HTML(
    '
    <div id="gallery" class="carousel slide carousel-dark" data-interval="false">

      <div class="carousel-inner">
        <div class="carousel-item active">
          <img class="mx-auto d-block" src="./static/img/Mapmixture1.jpeg" alt="Chicago" height="100%">
        </div>
        <div class="carousel-item">
          <img class="mx-auto d-block" src="./static/img/Mapmixture2.jpeg" alt="Chicago" height="100%">
        </div>
        <div class="carousel-item">
          <img class="mx-auto d-block" src="./static/img/Mapmixture3.jpeg" alt="Chicago" height="100%">
        </div>
        <div class="carousel-item">
          <img class="mx-auto d-block" src="./static/img/Mapmixture4.jpeg" alt="Chicago" height="100%">
        </div>
        <div class="carousel-item">
          <img class="mx-auto d-block" src="./static/img/Mapmixture5.jpeg" alt="Chicago" height="100%">
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
