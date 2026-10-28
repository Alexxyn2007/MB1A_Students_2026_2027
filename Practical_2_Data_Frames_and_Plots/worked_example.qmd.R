library(gt)
library(tidyverse)
install.packages("maps",dep=TRUE)
library(maps)
breeding_site <- read.csv("data/breeding_site_locations.csv")
gt(breeding_site)
colnames(breeding_site)
glimpse(breeding_site)
print(nrow(breeding_site))
print(ncol(breeding_site))
print(dim(breeding_site))
migration_sites <- read.csv("data/migratory_connectivity_dataset.csv")
gt(head(migration_sites))
glimpse(migration_sites)
print(dim(migration_sites))
colnames(migration_sites)

breeding_sites_selected <- breeding_site |>
  select(Site, Longitude, Latitude) |>
  distinct() |>
  rename(Breeding_Longitude = Longitude, Breeding_Latitude = Latitude)

gt(breeding_sites_selected)

bird_migration_selected <- migration_sites |>
  select(Site, winterLongitude, winterLatitude, pslon, pslat, iblon, iblat, awestlon, awestlat) |>
  distinct() |>
  rename(Winter_Longitude = winterLongitude, Winter_Latitude = winterLatitude, Stopover_Longitude = pslon, 
        Stopover_Latitude = pslat, Iberian_Longitude = iblon, Iberian_Latitude = iblat, 
        Westmost_Longitude = awestlon, Westmost_Latitude = awestlat)
gt(bird_migration_selected)

bird_breeding_exc <- breeding_sites_selected |> filter(Site != "Spain")
gt(bird_breeding_exc)
bird_migration_exc <- bird_migration_selected |> filter(Site != "Spain")
gt(bird_migration_exc)

bird_migration_grouped <- bird_migration_exc |> group_by(Site)
glimpse(bird_migration_grouped)
bird_migration_summary <- bird_migration_grouped |>
  summarise(
    Stopover_Latitude_med = median(Stopover_Latitude, na.rm = TRUE),
    Stopover_Longitude_med = median(Stopover_Longitude, na.rm = TRUE),
    Iberian_Longitude_med = median(Iberian_Longitude, na.rm = TRUE),
    Iberian_Latitude_med = median(Iberian_Latitude, na.rm = TRUE),
    Westmost_Longitude_med = median(Westmost_Longitude, na.rm = TRUE),
    Westmost_Latitude_med = median(Westmost_Latitude, na.rm = TRUE),
    Winter_Latitude_med = median(Winter_Latitude, na.rm = TRUE),
    Winter_Longitude_med = median(Winter_Longitude, na.rm = TRUE)
  )
gt(bird_migration_summary)

combined_bird_data <- full_join(bird_breeding_exc, bird_migration_summary)
gt(combined_bird_data)