#' File Format Tab Content
#'
#' @noRd
#' @description Return HTML string containing content for the File Format tabPanel

file_format_content <- function() {

  htmltools::HTML(
    '
    </br>
    <div class="accordion accordion-flush" id="accordionfileFormat">

        <div class="accordion-item">
            <h2 class="accordion-header" id="headingCoords">
                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseCoords" aria-expanded="false" aria-controls="collapseCoords">
                    <span class="fw-bold text-primary">Coordinates File Format</span>
                </button>
            </h2>
            <div id="collapseCoords" class="accordion-collapse collapse" aria-labelledby="headingCoords">
                <div class="accordion-body">

                    <p>
                        All three columns are mandatory. The first column contains the IDs for each site and can be a string, alphanumeric or number (numbers are converted to strings by default). The second and third columns are latitude and longitude, respectively. The units are decimal degrees and can be integers or decimals. Headers are required but can be any name.
                    </p>

                    <p>
                        <span class="text-danger fw-bold">Important:</span></br>

                        IDs in the <strong>Site</strong> column must <strong>match</strong> those in the Site column from the <strong>Admixture</strong> File.
                    </p>

                    <table class="table table-striped">
                        <thead>
                            <tr class="table-success">
                                <th scope="col">Site</th>
                                <th scope="col">Lat</th>
                                <th scope="col">Lon</th>
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

                    <p>Click <a href="https://github.com/Tom-Jenkins/mapmixture/blob/main/inst/extdata/coordinates.csv" target="_blank">here</a> to view an example CSV of this format.</p>

                </div>
            </div>
        </div>

        <div class="accordion-item">
            <h2 class="accordion-header" id="headingAdmixtureOption1">
                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseAdmixtureOption1" aria-expanded="false" aria-controls="collapseAdmixtureOption1">
                    <span class="fw-bold text-primary">Admixture File Format (Option 1 &#8212; Default)</span>
                </button>
            </h2>
            <div id="collapseAdmixtureOption1" class="accordion-collapse collapse" aria-labelledby="headingAdmixtureOption1">
                <div class="accordion-body">

                    <p>
                        The first three columns are mandatory and remaining columns are expected to be additional cluster (K) data. Each row represents data for a single individual. The first and second columns are IDs for sites and individuals, respectively. These IDs can be a string, alphanumeric or number (numbers are converted to strings by default). The cluster columns can be integers or decimals. Headers are required but can be any name.
                    </p>

                    <p>
                        <span class="text-danger fw-bold">Important:</span></br>

                        IDs in the <strong>Site</strong> column must <strong>match</strong> those in the Site column from the <strong>Coordinates</strong> File.</br>
                        IDs in the <strong>Individual</strong> column must be <strong>unique</strong>.</br>
                        Cluster values for each row must <strong>add up to 1</strong>.
                    </p>

                    <table class="table table-striped">
                        <thead>
                        <tr class="table-success">
                            <th scope="col">Site</th>
                            <th scope="col">Individual</th>
                            <th scope="col">Cluster 1</th>
                            <th scope="col">Cluster 2</th>
                            <th scope="col">Cluster 3</th>
                            <th scope="col">Cluster ...</th>
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

                    <p>Click <a href="https://github.com/Tom-Jenkins/mapmixture/blob/main/inst/extdata/admixture1.csv" target="_blank">here</a> to view an example CSV of this format.</p>

                </div>
            </div>
        </div>

        <div class="accordion-item">
            <h2 class="accordion-header" id="headingAdmixtureOption2">
                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseAdmixtureOption2" aria-expanded="false" aria-controls="collapseAdmixtureOption2">
                    <span class="fw-bold text-primary">Admixture File Format (Option 2 &#8212; Site Only)</span>
                </button>
            </h2>
            <div id="collapseAdmixtureOption2" class="accordion-collapse collapse" aria-labelledby="headingAdmixtureOption2">
                <div class="accordion-body">

                    <p>
                        The file format is the same as Option 1 except that each row represents a single site instead of a single individual. To avoid errors, simply copy the site ID from column one into column two.
                    </p>

                    <p>
                        <span class="text-danger fw-bold">Important:</span></br>

                        IDs in the <strong>Site</strong> column must <strong>match</strong> those in the Site column from the <strong>Coordinates</strong> File.</br>
                        Cluster values for each row must <strong>add up to 1</strong>.
                    </p>

                    <table class="table table-striped">
                        <thead>
                        <tr class="table-success">
                            <th scope="col">Site</th>
                            <th scope="col">Individual</th>
                            <th scope="col">Cluster 1</th>
                            <th scope="col">Cluster 2</th>
                            <th scope="col">Cluster 3</th>
                            <th scope="col">Cluster ...</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td>SiteA</td>
                            <td>SiteA</td>
                            <td>0.50</td>
                            <td>0.25</td>
                            <td>0.25</td>
                            <td>...</td>
                        </tr>
                        <tr>
                            <td>SiteB</td>
                            <td>SiteB</td>
                            <td>0.40</td>
                            <td>0.35</td>
                            <td>0.25</td>
                            <td>...</td>
                        </tr>
                        <tr>
                            <td>SiteC</td>
                            <td>SiteC</td>
                            <td>0.05</td>
                            <td>0.05</td>
                            <td>0.90</td>
                            <td>...</td>
                        </tr>
                        <tr>
                            <td>SiteD</td>
                            <td>SiteD</td>
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

                    <p>Click <a href="https://github.com/Tom-Jenkins/mapmixture/blob/main/inst/extdata/admixture2.csv" target="_blank">here</a> to view an example CSV of this format.</p>

                </div>
            </div>
        </div>

        <div class="accordion-item">
            <h2 class="accordion-header" id="headingAdmixtureOption3">
                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseAdmixtureOption3" aria-expanded="false" aria-controls="collapseAdmixtureOption3">
                    <span class="fw-bold text-primary">Admixture File Format (Option 3 &#8212; Site Only & Single Cluster Colour)</span>
                </button>
            </h2>
            <div id="collapseAdmixtureOption3" class="accordion-collapse collapse" aria-labelledby="headingAdmixtureOption3">
                <div class="accordion-body">
                    <p>
                        The file format is the same as Option 2 except that each site has only a single colour assigned to it.
                    </p>

                    <p>
                        <span class="text-danger fw-bold">Important:</span></br>

                        IDs in the <strong>Site</strong> column must <strong>match</strong> those in the Site column from the <strong>Coordinates</strong> File.</br>
                        For each row, only one cluster column can be assigned 1. All other cluster columns must be assigned 0.
                    </p>

                    <table class="table table-striped">
                        <thead>
                        <tr class="table-success">
                            <th scope="col">Site</th>
                            <th scope="col">Individual</th>
                            <th scope="col">Cluster 1</th>
                            <th scope="col">Cluster 2</th>
                            <th scope="col">Cluster 3</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td>SiteA</td>
                            <td>SiteA</td>
                            <td>1</td>
                            <td>0</td>
                            <td>0</td>
                        </tr>
                        <tr>
                            <td>SiteB</td>
                            <td>SiteB</td>
                            <td>0</td>
                            <td>1</td>
                            <td>0</td>
                        </tr>
                        <tr>
                            <td>SiteC</td>
                            <td>SiteC</td>
                            <td>0</td>
                            <td>1</td>
                            <td>0</td>
                        </tr>
                        <tr>
                            <td>SiteD</td>
                            <td>SiteD</td>
                            <td>0</td>
                            <td>0</td>
                            <td>1</td>
                        </tr>
                        <tr>
                            <td>...</td>
                            <td>...</td>
                            <td>...</td>
                            <td>...</td>
                            <td>...</td>
                        </tr>
                        </tbody>
                    </table>

                    <p>Click <a href="https://github.com/Tom-Jenkins/mapmixture/blob/main/inst/extdata/admixture3.csv" target="_blank">here</a> to view an example CSV of this format.</p>

                </div>
            </div>
        </div>

    </div>
    '
  )
}
