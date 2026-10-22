<template>
  <LMap :zoom="zoom" :center="center" style="height:100%; width:100%" :options="{ attributionControl: false }" @ready="onMapReady">
    <LTileLayer layer-type="base" name="Map" url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"/>
    <LTileLayer layer-type="base" name="Satellite" url="https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}"/>
  </LMap>
</template>

<script>
import L from 'leaflet'
import 'leaflet-draw'
export default {
  name: 'SelectArea',
  props: {
    center: { type: Object, required: true },
    zoom: { type: Number, default: 13 },
    polygon: { type: Array, default: () => [] },
    marker: { type: [Object, Array, null], default: null },
    options: { type: Number, default: 3 },
  },
  emits: ['result_polygon', 'result_marker'],
  data() {
    return {
      map: null,
      polygonLayer: null,
      markerLayer: null,
    }
  },
  watch: {
    polygon(newPolygon) {
      if (newPolygon && this.map) {
        this.updatePolygon(newPolygon)
      }
    },
    marker(newMarker) {
      if (newMarker && this.map) {
        this.updateMarker(newMarker)
      }
    },
  },
  methods: {
    onMapReady(leafletMap) {
      this.map = leafletMap

      const baseMaps = {
        "Map": L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"),
        "Satellite": L.tileLayer("https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}")
      }
      L.control.layers(baseMaps).addTo(this.map)
      baseMaps["Map"].addTo(this.map)

      const drawControl = new L.Control.Draw({
        edit: {
          featureGroup: L.featureGroup([]),
          remove: false,
          edit: false,
        },
        draw: {
          polygon: (this.options === 2 || this.options === 3) ? true : false,
          rectangle: false,
          circle: false,
          circlemarker: false,
          marker: (this.options === 1 || this.options === 3) ? true : false,
          polyline: false,
        },
      })
      drawControl.addTo(this.map)
      this.map._controlCorners.bottomleft.appendChild(drawControl._container)

      // Initialize with props
      if (this.polygon?.length) {
        this.updatePolygon(this.polygon)
      }
      if (this.marker) {
        this.updateMarker(this.marker)
      }

      // Listen for draw created
      this.map.on(L.Draw.Event.CREATED, (event) => {
        const { layerType, layer } = event

        if (layerType === 'polygon') {
          if (this.polygonLayer) this.map.removeLayer(this.polygonLayer)
          this.polygonLayer = layer
          this.polygonLayer.addTo(this.map)
          this.$emit('result_polygon', this.polygonLayer.getLatLngs()[0])
        } else if (layerType === 'marker') {
          if (this.markerLayer) this.map.removeLayer(this.markerLayer)
          this.markerLayer = layer
          this.markerLayer.addTo(this.map)
          this.$emit('result_marker', this.markerLayer.getLatLng())
        }
      })

      // Listen for edits
      this.map.on(L.Draw.Event.EDITED, (event) => {
        event.layers.eachLayer((layer) => {
          if (layer === this.polygonLayer) {
            this.$emit('result_polygon', layer.getLatLngs()[0])
          } else if (layer === this.markerLayer) {
            this.$emit('result_marker', layer.getLatLng())
          }
        })
      })
    },

    updatePolygon(coordinates) {
      if (this.polygonLayer) {
        this.map.removeLayer(this.polygonLayer)
      }
      // Leaflet expects an array of arrays
      this.polygonLayer = L.polygon([coordinates])
      this.polygonLayer.addTo(this.map)
      this.map.fitBounds(this.polygonLayer.getBounds())
    },

    updateMarker(coordinates) {
      if (this.markerLayer) {
        this.map.removeLayer(this.markerLayer)
      }

      // If array is passed, take the first one
      const point = Array.isArray(coordinates) ? coordinates[0] : coordinates
      this.markerLayer = L.marker(point)
      this.markerLayer.addTo(this.map)
      this.map.panTo(this.markerLayer.getLatLng())
    },
  },
}
</script>
