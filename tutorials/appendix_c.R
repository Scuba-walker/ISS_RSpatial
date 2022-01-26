#### Anatomy of simple feature objects ####

# understand the building blocks of simple feature objects via creation of 
# point, polyline and polygon features

### Creating point 'sf' objects ####
## step 1 creating the point geometry ##
library(sf)
library(sf)
p1.sfg <- st_point(c(-70, 45)) 
p2.sfg <- st_point(c(-69, 44)) 
p3.sfg <- st_point(c(-69, 45)) 

class(p1.sfg)

# create multipoint
mp <- st_multipoint(matrix(c(-70, 45, -69, 44, -69, 45), ncol = 2, byrow = TRUE ))

## step 2 create a column of simple feature geometries ##
p.sfc <- st_sfc( list(p1.sfg, p2.sfg, p3.sfg), crs = 4326 )
class(p.sfc)
p.sfc[[2]]

## step 3 create the simple feature object ##
p.sf <- st_sf(p.sfc)
p.sf

attributes(p.sf)

# You can use the names() function to rename that column, but note that you will 
# need to re-define the geometry column in the attributes using the st_geometry() 
# function.
names(p.sf) <- "coords"
st_geometry(p.sf) <- "coords"
p.sf

## adding attributes to an sf object ##
typeof(p.sf$geom)

# assign letters to each point
p.sf$val1 <- c("A", "B", "C")

p.sf

plot(p.sf, pch = 16, axes = TRUE, main = NULL)

## adding a geometry column to an existing non-spatial dataframe ##
df <- data.frame(col1 = c("A", "B","C"))
st_geometry(df) <- p.sfc

df
# that is neat!

### Creating polyline 'sf' objects ####
# the order in which the vertices are defined matters
# the order defines each connecting line segment ends
l <- rbind( c(-70, 45), c(-69, 44), c(-69, 45) )

# create a polyline geometry object
l.sfg <- st_linestring(l)

# create a simple feature column and add reference system definition
l.sfc <- st_sfc(list(l.sfg), crs = 4326)

# finally create the simple feature object
l.sf <- st_sf(l.sfc) # all associated with a single polyline feature even though it is multipart

plot(l.sf, type = "b", pch = 16, main = NULL, axes = TRUE)

## creating branching polyline features ##
# Define coordinate pairs
l1 <- rbind( c(-70, 45), c(-69, 44), c(-69, 45) )
l2 <- rbind( c(-69, 44), c(-70, 44) )
l3 <- rbind( c(-69, 44), c(-68, 43) )

# Create simple feature geometry object
l.sfg <- st_multilinestring(list(l1, l2, l3))

# Create simple feature column object
l.sfc <- st_sfc(list(l.sfg), crs = 4326)

# Create simple feature object
l.sf <- st_sf(l.sfc)

# Plot the data
plot(l.sf, type = "b", pch = 16, axes = TRUE)


### Creating polygon 'sf' objects ####
# very interesting - the area to the left in sf objects define the area
# area to the right in shapefile objects define the area
poly1.crd <- rbind( c(-66, 43), c(-70, 47), c(-70,43),  c(-66, 43) )

# create a polygon geometry object
poly1.geom <- st_polygon( list(poly1.crd ) )

# create a simple feature column from polygon geometry
poly.sfc <- st_sfc( list(poly1.geom), crs = 4326 )

# create sf object 
poly.sf <- st_sf(poly.sfc)
poly.sf

# rename column
names(poly.sf) <- "coords"
st_geometry(poly.sf) <- "coords"
poly.sf

# plot polygon
plot(poly.sf, col = "bisque", axes = TRUE)

## create polygon with a hole ##
# Polygon 1
poly1.outer.crd <- rbind( c(-66, 43),c(-70, 47), c(-70,43), c(-66, 43) ) # Outer ring
poly1.inner.crd  <- rbind( c(-68, 44), c(-69,44), c(-69, 45), c(-68, 44) ) # Inner ring

# combine the ring coordinates into a single geometric element
poly1.geom <- st_polygon( list(poly1.outer.crd, poly1.inner.crd))

# create simple feature column object
poly.sfc <- st_sfc( list(poly1.geom), crs = 4326 )

# create the sf object
poly.sf <- st_sf(poly.sfc)

# rename coord
names(poly.sf) <- "coords"
st_geometry(poly.sf) <- "coords"
poly.sf

# plot
plot(poly.sf, col = "bisque", axes = TRUE)

### Combining polygons: singlepart features ####
# Define coordinate matrix
poly2.crd <- rbind( c(-67, 45),c(-67, 47), c(-69,47), c(-67, 45) ) 

# Create polygon geometry
poly2.geom <- st_polygon( list(poly2.crd))

# combine geometries into a single feature column
poly.sfc <- st_sfc( list(poly1.geom , poly2.geom), crs = 4326 )

# create sf object
poly.sf <- st_sf(poly.sfc)
poly.sf

# rename coords
names(poly.sf) <- "coords"
st_geometry(poly.sf) <- "coords"
poly.sf

# plot
plot(poly.sf, col = "bisque", axes = TRUE)

## adding attributes ##
poly.sf$id <- c("A", "B")
poly.sf

# plot according to ID
plot(poly.sf["id"],  axes = TRUE, main = NULL)

### Combining polygons: multipart features ####
# the multipart function groups polygons into a single list
# Create multipolygon geometry
mpoly1.sfg  <- st_multipolygon( list(
  list( poly1.outer.crd,  # Outer loop
        poly1.inner.crd), # Inner loop
  list( poly2.crd)) )     # Separate polygon

# Create simple feature column object
mpoly.sfc <- st_sfc( list(mpoly1.sfg), crs = 4326)

# Create simple feature object
mpoly.sf <- st_sf(mpoly.sfc)

mpoly.sf

### Mixing singlepart and multipart elements ####
# this is very interesting, I don't think arcgis can do this

# a multipolygon geometry can be used to store a single polygon as well
poly3.coords <- rbind( c(-66, 44), c(-64, 44), c(-66,47), c(-66, 44) )
poly4.coords <- rbind( c(-67, 43), c(-64, 46), c(-66.5,46), c(-67, 43) ) 

# note the embedded list() functions in the following code
mpoly1.sfg  <- st_multipolygon( list(
  list( poly1.outer.crd,  # Outer loop
        poly1.inner.crd), # Inner loop
  list( poly2.crd)) )     # Separate poly
mpoly2.sfg  <- st_multipolygon( list(
  list(poly3.coords)))  # Unique polygon
mpoly3.sfg  <- st_multipolygon( list(
  list(poly4.coords)) )  # Unique polygon

# create sf column object
mpoly.sfc <- st_sfc( list(mpoly1.sfg, mpoly2.sfg, mpoly3.sfg), crs = 4326)

# create sf object
mpoly.sf <- st_sf(mpoly.sfc)

# add attribute values and plot
mpoly.sf$ids <- c("A", "B", "C")
plot(mpoly.sf["ids"], axes = TRUE, main = NULL,
     pal = sf.colors(alpha = 0.5, categorical = TRUE))

# check that this does not violate sf rules
st_is_valid(mpoly.sf)

### Extracting geometry from sf object ####
# Create sfc from sf
st_geometry(mpoly.sf)

# extract coord from a single record in a WKT format
st_geometry(mpoly.sf)[[1]]

# extract coord pairs of the first element in a list format type
st_geometry(mpoly.sf)[[1]][]
