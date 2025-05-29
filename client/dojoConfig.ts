import { createDojoConfig } from "@dojoengine/core";

import manifest from "../chess/manifest_dev.json";

export const dojoConfig = createDojoConfig({
    manifest,
});
