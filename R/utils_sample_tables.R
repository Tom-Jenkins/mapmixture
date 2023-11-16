#' Sample Tables Content
#'
#' @noRd
#' @description Return HTML string containing content for the sample tables

admixture_sample_table <- function() {

  htmltools::HTML(
    "
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
              <td>Sample3</td>
              <td>0.05</td>
              <td>0.05</td>
              <td>0.90</td>
              <td>...</td>
          </tr>
          <tr>
              <td>SiteB</td>
              <td>Sample4</td>
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
      <span class='d-block p-2 bg-warning text-white'>The site IDs in the <span class='fw-bold'>Site</span> column must match those in the <span class='fw-bold'>Site</span> column from the <span class='fw-bold'>Coordinates</span> File.</span>
      "
  )
}

coords_sample_table <- function() {

  htmltools::HTML(
    "
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
    <span class='d-block p-2 bg-warning text-white'>
      The site IDs in the <span class='fw-bold'>Site</span> column must match those in the <span class='fw-bold'>Site</span> column from the <span class='fw-bold'>Admixture</span> File.
    </span>
    "
  )
}
