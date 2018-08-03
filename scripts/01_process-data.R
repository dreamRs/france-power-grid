

#  ------------------------------------------------------------------------
#
# Title : Import data
#    By : Victor
#  Date : 2018-08-02
#    
#  ------------------------------------------------------------------------



# Packages ----------------------------------------------------------------

library( data.table )
library( janitor )



# Import ------------------------------------------------------------------

# 163M to download
fr_cons <- fread("https://data.enedis.fr/explore/dataset/consommation-electrique-par-secteur-dactivite-iris/download/?format=csv&timezone=Europe/Berlin&use_labels_for_header=true")
saveRDS(fr_cons, file = "datas/raw.rds")

fr_cons <- readRDS(file = "datas/raw.rds")

# Clean names
setnames(fr_cons, names(fr_cons), stringr::str_conv(names(fr_cons), "UTF-8"))
fr_cons <- clean_names(fr_cons)

# keep only 2016
fr_cons <- fr_cons[annee == 2016]


# select interesting columns
fr_cons <- fr_cons[, list(
  code_iris, nom_commune, code_commune, code_departement, geo_point_2d, 
  nb_sites_residentiel, conso_totale_residentiel_m_wh, 
  nb_sites_professionnel, conso_totale_professionnel_m_wh,
  nb_sites_agriculture, conso_totale_agriculture_m_wh,
  nb_sites_industrie, conso_totale_industrie_m_wh
)]

# encoding issue
fr_cons[, nom_commune := stringr::str_conv(nom_commune, "UTF-8")]
fr_cons


# location columns
fr_cons[, (c("lat", "lon")) := tstrsplit(geo_point_2d, split = ", ", type.convert = TRUE)]


# save data
saveRDS(object = fr_cons, file = "datas/fr_cons_2016.rds")



