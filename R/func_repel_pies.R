#' Repel Pie Chart Positions
#'
#' @description
#' Compute displaced positions for overlapping pie charts using a
#' force-directed algorithm (spring force + repulsion + damping).
#' @keywords internal
#'
#' @param x numeric vector of x coordinates (longitude).
#' @param y numeric vector of y coordinates (latitude).
#' @param radius numeric vector of pie radii (same length as x, or length 1).
#' @param force multiplier for repulsion force. Higher values = faster separation.
#' @param max_iter maximum number of iterations.
#' @param damping velocity damping factor (0-1). Lower = more damping.
#' @param spring_force strength of spring pulling pie back toward anchor.
#' @param padding extra spacing between pies as a proportion of radius (e.g. 0.1 = 10%).
#'
#' @return A data.frame with columns x, y (displaced positions) and
#'   x_orig, y_orig (original positions).
#' @export
repel_pies <- function(
  x,
  y,
  radius,
  force = 1,
  max_iter = 500,
  damping = 0.65,
  spring_force = 0.05,
  padding = 0.1
) {
  n <- length(x)

  if (length(radius) == 1) {
    radius <- rep(radius, n)
  }

  radii <- radius * (1 + padding)

  # Determine which pies actually overlap (using true radius, no padding)
  moveable <- rep(FALSE, n)
  for (i in seq_len(n)) {
    for (j in seq_len(n)) {
      if (i == j) {
        next
      }
      dist <- sqrt((x[i] - x[j])^2 + (y[i] - y[j])^2)
      if (dist < radius[i] + radius[j]) {
        moveable[i] <- TRUE
        moveable[j] <- TRUE
      }
    }
  }

  # Initialise displaced positions at original coordinates
  dx <- x
  dy <- y

  # Initialise velocity vectors
  vx <- rep(0, n)
  vy <- rep(0, n)

  for (iter in seq_len(max_iter)) {
    total_force <- 0

    for (i in seq_len(n)) {
      # Skip pies that don't overlap with anything
      if (!moveable[i]) {
        next
      }

      fx <- 0
      fy <- 0

      # Repulsion forces from other pies
      for (j in seq_len(n)) {
        if (i == j) {
          next
        }

        diff_x <- dx[i] - dx[j]
        diff_y <- dy[i] - dy[j]
        dist <- sqrt(diff_x^2 + diff_y^2)
        min_dist <- radii[i] + radii[j]

        if (dist < min_dist && dist > 0) {
          overlap <- min_dist - dist
          fx <- fx + (diff_x / dist) * overlap * force
          fy <- fy + (diff_y / dist) * overlap * force
        }
      }

      # Spring force pulling back toward original position
      fx <- fx - (dx[i] - x[i]) * spring_force
      fy <- fy - (dy[i] - y[i]) * spring_force

      # Update velocity with damping
      vx[i] <- (vx[i] + fx) * damping
      vy[i] <- (vy[i] + fy) * damping

      total_force <- total_force + abs(fx) + abs(fy)
    }

    # Apply velocity to positions
    dx <- dx + vx
    dy <- dy + vy

    # Early exit if converged (forces are negligible)
    if (total_force < 1e-6 * mean(radii)) break
  }

  data.frame(
    x = dx,
    y = dy,
    x_orig = x,
    y_orig = y
  )
}
