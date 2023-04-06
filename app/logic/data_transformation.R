# app/logic/data_transformation.R

# Import R packages / functions into module
box::use(
    tidyr[pivot_longer],
    ggplot2[ggplot, aes, geom_bar, coord_polar, scale_fill_manual, theme_void],
    magrittr[`%>%`],
    dplyr[group_by, summarise, arrange, n_distinct, left_join],
    tidyr[pivot_wider, tibble],
    purrr[map],
    stringr[str_to_lower],
    sf[st_as_sf, st_set_crs, st_transform, st_coordinates, st_as_sfc, st_bbox],
)


#' @export
transform_data <- function(data) {
    pivot_longer(data, cols = c(3:ncol(data)), names_to = "cluster", values_to = "admixture")
}


#' @export
prepare_pie_data <- function(data) {
    
    data %>% 
      # Calculate mean admixture proportions for each site
      group_by(site, cluster) %>%
      summarise(admixture = mean(admixture)) %>%
      # Convert to the format required for scatterpie 
      pivot_wider(names_from = cluster, values_from = admixture) %>% 
      # Order rows by site
      arrange(site)
}


#' @export
merge_coords_data <- function(coord_df, pie_df, CRS) {
    # Convert headers to lowercase
    colnames(coord_df) <- str_to_lower(colnames(coord_df))

    # Convert to sf object and transform to CRS
    coord_sf <- coord_df %>% 
      st_as_sf(coords = c("lon","lat")) %>%
      arrange(site) %>%
      st_set_crs(4326) %>% 
      st_transform(crs = CRS)

    # Join piedata with sf object by site
    piecoords <- tibble(
      site = coord_sf$site,
      lon = st_coordinates(coord_sf)[,"X"],
      lat = st_coordinates(coord_sf)[,"Y"]
      ) %>%
      left_join(pie_df, "site")

    # Return tibble
    return(piecoords)
}   


#' @export
transform_bbox <- function(bbox, CRS) {

  bbox %>%
    st_as_sfc() %>%
    st_transform(crs = CRS) %>%
    st_bbox()
}

