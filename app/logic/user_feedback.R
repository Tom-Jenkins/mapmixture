# app/logic/user_feedback.R

# Import R packages / functions into module
box::use(
    shinyFeedback[showFeedbackWarning, hideFeedback]
)

#' @export
download_parameter_shinyfeedback <- function(id) {
    # Feedback on element when empty string or NA
    if (input[[ns(id)]] == "" || is.na(as.numeric(input[[ns(id)]]))) {
        showFeedbackWarning(inputId = id, text = NULL, icon = NULL)  
    } else {
        hideFeedback(id)
    } 
}