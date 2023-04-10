# Installing necessary packages

install.packages("palmerpenguins")
install.packages("tidyverse")
install.packages("dplyr")

# Load the installed and required packages

library(tidyverse)
library(palmerpenguins)
library(dplyr)
library(skimr)


# Exploring the data

# Show the first 6 row
head(penguins)

# Show the column names
colnames(penguins)

# Display the structure of the data
str(penguins)

# Display Data summary
skim_without_charts(penguins)
glimpse(penguins)

# Add a new column to the data
penguins <- penguins %>% mutate(body_mass_kg = body_mass_g/1000)

# Check the number of males and females
penguins %>%
  count(sex)

# Filter out the rows where sex is NA
filtered_data <- penguins %>% filter(sex != 'NA')

# Visualize the sex column with bar chart
ggplot(data=filtered_data)+geom_bar(mapping=aes(x=sex,fill=sex))

# Check the number of species in the data
penguins %>%
  count(species)

# Visualize the species column with bar chart
ggplot(data=penguins)+geom_bar(mapping=aes(x=species,fill=species))

# Display Data summary on the filtered data
filtered_data %>% summary()
skim_without_charts(filtered_data)

# Mean value of each column per penguin type
penguins %>% 
  group_by(species) %>% 
  summarize(across(where(is.numeric), mean, na.rm = TRUE))

# Visualizing the data

## Analyzing the relationship between flipper length vs body mass

ggplot(data=penguins)+geom_point(mapping=aes(x=flipper_length_mm, y=body_mass_g))+
  labs(title="Flipper length vs Body mass",subtitle="This show the relationship between flipper length and body mass across all species",caption="Data collected by Dr. Kristen Gorman")

ggplot(data=penguins)+geom_point(mapping=aes(x=flipper_length_mm, y=body_mass_g,color=species,shape=species))+
  labs(title="Flipper length vs Body mass",subtitle="This show the relationship between flipper length and body mass across all species",caption="Data collected by Dr. Kristen Gorman")

ggplot(data=penguins)+geom_point(mapping=aes(x=flipper_length_mm, y=body_mass_g,color=species,shape=species)) +
  geom_smooth(mapping=aes(x=flipper_length_mm, y=body_mass_g),color = 'black')+
  labs(title="Flipper length vs Body mass",subtitle="This show the relationship between flipper length and body mass across all species",caption="Data collected by Dr. Kristen Gorman")


penguins %>% filter(species == "Adelie")  %>% ggplot()+geom_point(mapping=aes(x=flipper_length_mm, y=body_mass_g))+
  geom_smooth(mapping=aes(x=flipper_length_mm, y=body_mass_g),color = 'black')+
  labs(title="Flipper length vs Body mass",subtitle="This show the relationship between flipper length and body mass for adelie",caption="Data collected by Dr. Kristen Gorman")


penguins %>% filter(species == "Chinstrap")  %>% ggplot()+geom_point(mapping=aes(x=flipper_length_mm, y=body_mass_g))+
  geom_smooth(mapping=aes(x=flipper_length_mm, y=body_mass_g),color = 'black')+
  labs(title="Flipper length vs Body mass",subtitle="This show the relationship between flipper length and body mass for chinstrap",caption="Data collected by Dr. Kristen Gorman")


penguins %>% filter(species == "Gentoo")  %>% ggplot()+geom_point(mapping=aes(x=flipper_length_mm, y=body_mass_g))+
  geom_smooth(mapping=aes(x=flipper_length_mm, y=body_mass_g),color = 'black')+
  labs(title="Flipper length vs Body mass",subtitle="This show the relationship between flipper length and body mass for gentoo",caption="Data collected by Dr. Kristen Gorman")


ggplot(data=penguins)+geom_point(mapping=aes(x=flipper_length_mm, y=body_mass_g,color=species,shape=species))+
  facet_wrap(~species)+
  labs(title="Flipper length vs Body mass",subtitle="This show the relationship between flipper length and body mass across all species separately",caption="Data collected by Dr. Kristen Gorman")


ggplot(data=filtered_data)+geom_point(mapping=aes(x=flipper_length_mm, y=body_mass_g,color=species,shape=species))+
  facet_wrap(~sex)+
  labs(title="Flipper length vs Body mass",subtitle="This show the effect of the sex on the relationship between flipper length and body mass",caption="Data collected by Dr. Kristen Gorman")



## Analyzing the relationship between bill length vs body mass

ggplot(data=penguins)+geom_point(mapping=aes(x=bill_length_mm, y=body_mass_g))+
  labs(title="Bill length vs Body mass",subtitle="This show the relationship between bill length and body mass across all species",caption="Data collected by Dr. Kristen Gorman")


ggplot(data=penguins)+geom_point(mapping=aes(x=bill_length_mm, y=body_mass_g,color=species,shape=species))+
  labs(title="Bill length vs Body mass",subtitle="This show the relationship between bill length and body mass across all species",caption="Data collected by Dr. Kristen Gorman")

ggplot(data=penguins)+geom_point(mapping=aes(x=bill_length_mm, y=body_mass_g,color=species,shape=species)) +
  geom_smooth(mapping=aes(x=bill_length_mm, y=body_mass_g),color = 'black')+
  labs(title="Bill length vs Body mass",subtitle="This show the relationship between bill length and body mass across all species",caption="Data collected by Dr. Kristen Gorman")

penguins %>% filter(species == "Adelie")  %>% ggplot()+geom_point(mapping=aes(x=bill_length_mm, y=body_mass_g))+
  geom_smooth(mapping=aes(x=bill_length_mm, y=body_mass_g),color = 'black')+
  labs(title="Bill length vs Body mass",subtitle="This show the relationship between bill length and body mass for adelie",caption="Data collected by Dr. Kristen Gorman")


penguins %>% filter(species == "Chinstrap")  %>% ggplot()+geom_point(mapping=aes(x=bill_length_mm, y=body_mass_g))+
  geom_smooth(mapping=aes(x=bill_length_mm, y=body_mass_g),color = 'black')+
  labs(title="Bill length vs Body mass",subtitle="This show the relationship between bill length and body mass for chinstrap",caption="Data collected by Dr. Kristen Gorman")


penguins %>% filter(species == "Gentoo")  %>% ggplot()+geom_point(mapping=aes(x=bill_length_mm, y=body_mass_g))+
  geom_smooth(mapping=aes(x=bill_length_mm, y=body_mass_g),color = 'black')+
  labs(title="Bill length vs Body mass",subtitle="This show the relationship between bill length and body mass for gentoo",caption="Data collected by Dr. Kristen Gorman")


ggplot(data=penguins)+geom_point(mapping=aes(x=bill_length_mm, y=body_mass_g,color=species,shape=species))+
  facet_wrap(~species)+
  labs(title="Bill length vs Body mass",subtitle="This show the relationship between bill length and body mass across all species",caption="Data collected by Dr. Kristen Gorman")


ggplot(data=filtered_data)+geom_point(mapping=aes(x=bill_length_mm, y=body_mass_g,color=species,shape=species))+
  facet_wrap(~sex)+
  labs(title="Bill length vs Body mass",subtitle="This show the effect of the sex on the relationship between bill length and body mass",caption="Data collected by Dr. Kristen Gorman")



## Analyzing the effect of the location on the relationship of the physical characteristics

ggplot(data=filtered_data)+geom_point(mapping=aes(x=bill_length_mm, y=body_mass_g,color=species,shape=species))+
  facet_wrap(~island)+
  geom_smooth(mapping=aes(x=bill_length_mm, y=body_mass_g),color = 'black')+
  labs(title="Bill length vs Body mass",subtitle="This show the effect of the location on the relationship between bill length and body mass",caption="Data collected by Dr. Kristen Gorman")


ggplot(data=filtered_data)+geom_point(mapping=aes(x=flipper_length_mm, y=body_mass_g,color=species,shape=species))+
  facet_wrap(~island)+
  geom_smooth(mapping=aes(x=flipper_length_mm, y=body_mass_g),color = 'black')+
  labs(title="Flipper length vs Body mass",subtitle="This show the effect of the location on the relationship between flipper length and body mass",caption="Data collected by Dr. Kristen Gorman")

