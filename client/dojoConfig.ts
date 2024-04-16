import manifest from "../contracts/manifests/dev/manifest.json";
import { createDojoConfig } from "@dojoengine/core";

export const dojoConfig = createDojoConfig({
    manifest : manifest,
    rpcUrl : "https://api.cartridge.gg/x/chess/katana",
    toriiUrl : "https://api.cartridge.gg/x/chess/torii",
    masterAddress : "0x5250ca23605451bbbd9d2ea1a5ccc6c4b420158ec0f3fed5ce218d4935a39eb",
    masterPrivateKey : "0x41a79ff14d3e147d54ed5f03ccdd5fcee8aca44576ba55e4ab7752ea239b631",

});
