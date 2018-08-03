

#  ------------------------------------------------------------------------
#
# Title : Visualize data
#    By : Victor
#  Date : 2018-08-02
#    
#  ------------------------------------------------------------------------



# Packages ----------------------------------------------------------------

library( data.table )
library( mapdeck )


token <- readLines("token-mapbox")



# Data --------------------------------------------------------------------

fr_cons <- readRDS(file = "datas/fr_cons_2016.rds")


idf_resid <- fr_cons[!is.na(nb_sites_residentiel) & code_departement %in% c(75, 77, 78, 91, 92, 93, 94, 95)]
idf_resid <- idf_resid[rep(seq_len(.N), times = nb_sites_residentiel)]

fr_resid <- fr_cons[!is.na(nb_sites_residentiel)]
fr_resid <- fr_resid[rep(seq_len(.N), times = ceiling(nb_sites_residentiel/10))]

fr_resid_consomoy <- fr_cons[!is.na(nb_sites_residentiel)]
fr_resid_consomoy[, conso_moy := log1p(conso_totale_residentiel_m_wh / nb_sites_residentiel)]
fr_resid_consomoy <- fr_resid_consomoy[!is.na(conso_moy)]
fr_resid_consomoy <- fr_resid_consomoy[rep(seq_len(.N), times = scales::rescale(conso_moy, to = c(1, 100)))]

fr_resid_conso <- fr_cons[!is.na(nb_sites_residentiel) & !is.na(conso_totale_residentiel_m_wh)]
fr_resid_conso[, conso_log := log1p(conso_totale_residentiel_m_wh)]

fr_resid_conso <- fr_resid_conso[rep(seq_len(.N), times = scales::rescale(conso_log, to = c(1, 100)))]





# Maps --------------------------------------------------------------------

# IdF (number of homes connected to the electricity grid)
m <- mapdeck(
  token = token,
  style = 'mapbox://styles/mapbox/dark-v9',
  pitch = 0, 
  location = c(5, 50), 
  zoom = 4
) %>%
  add_grid(
    data = as.data.frame(idf_resid),
    lat = "lat",
    lon = "lon",
    cell_size = 1000,
    elevation_scale = 50,
    layer_id = "grid_layer"
  )

# htmlwidgets::saveWidget(m, file = "idf.html")

htmltools::html_print(html = m, viewer = browseURL)


# France (number of housings connected to the electricity grid)
m <- mapdeck(
  token = token,
  style = 'mapbox://styles/mapbox/dark-v9',
  pitch = 0, 
  location = c(5, 50), 
  zoom = 4,
  height = 800
) %>%
  add_grid(
    data = as.data.frame(fr_resid),
    lat = "lat",
    lon = "lon",
    cell_size = 2000,
    elevation_scale = 50,
    layer_id = "grid_layer"
  )

htmltools::html_print(html = m, viewer = browseURL)

htmlwidgets::saveWidget(m, file = "index.html", selfcontained = FALSE)


# France (average consumption)
m <- mapdeck(
  token = token,
  style = 'mapbox://styles/mapbox/dark-v9',
  pitch = 0, 
  location = c(5, 50), 
  zoom = 4,
  height = 800
) %>%
  add_grid(
    data = as.data.frame(fr_resid_consomoy),
    lat = "lat",
    lon = "lon",
    cell_size = 1000,
    elevation_scale = 500,
    layer_id = "grid_layer"
  )

htmltools::html_print(html = m, viewer = browseURL)


# France (residentiel consumption)
m <- mapdeck(
  token = token,
  style = 'mapbox://styles/mapbox/dark-v9',
  pitch = 0, 
  location = c(5, 50), 
  zoom = 4,
  height = 800
) %>%
  add_grid(
    data = as.data.frame(fr_resid_conso),
    lat = "lat",
    lon = "lon",
    cell_size = 1000,
    elevation_scale = 50,
    layer_id = "grid_layer"
  )

htmltools::html_print(html = m, viewer = browseURL)
