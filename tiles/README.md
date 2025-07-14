# Tileserver-GL Configuration

This directory contains the configuration for the self-hosted map tile server.

## Required Setup

1.  **Download Map Data:**
    You need a map data file in `.mbtiles` format. We recommend starting with a small country extract from a provider like [OpenMapTiles](https://openmaptiles.com/downloads/planet/).

    *   **Direct Download Link (Switzerland):** [switzerland.mbtiles](https://download.openmaptiles.com/extracts/switzerland.mbtiles) (approx. 240MB)
    *   For smaller files for testing, search for city or region extracts.

2.  **Place the File:**
    Place the downloaded `.mbtiles` file inside this `tiles/` directory. The `docker-compose.yml` file is configured to automatically find and serve any `.mbtiles` file located here.

The server will be available at `http://localhost:8080`. 