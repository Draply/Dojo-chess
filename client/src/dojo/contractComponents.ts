/* Autogenerated file. Do not edit manually. */

import { defineComponent, Type as RecsType, World } from "@dojoengine/recs";

export type ContractComponents = Awaited<ReturnType<typeof defineContractComponents>>;

export function defineContractComponents(world: World) {
  return {
    Game: (() => {
      return defineComponent(
        world,
        { game_id: RecsType.Number, winner: RecsType.Number, white: RecsType.BigInt, black: RecsType.BigInt },
        {
          metadata: {
            name: "Game",
            types: ["u32","enum","contractaddress","contractaddress"],
            customTypes: ["Color"],
          },
        }
      );
    })(),
    GameTurn: (() => {
      return defineComponent(
        world,
        { game_id: RecsType.Number, player_color: RecsType.Number, game_win: RecsType.Boolean },
        {
          metadata: {
            name: "GameTurn",
            types: ["u32","enum","bool"],
            customTypes: ["Color"],
          },
        }
      );
    })(),
    Piece: (() => {
      return defineComponent(
        world,
        { game_id: RecsType.Number, position: { x: RecsType.Number, y: RecsType.Number }, color: RecsType.Number, piece_type: RecsType.Number },
        {
          metadata: {
            name: "Piece",
            types: ["u32","u32","u32","enum","enum"],
            customTypes: ["Vec2","Color","PieceType"],
          },
        }
      );
    })(),
    Player: (() => {
      return defineComponent(
        world,
        { game_id: RecsType.Number, address: RecsType.BigInt, color: RecsType.Number },
        {
          metadata: {
            name: "Player",
            types: ["u32","contractaddress","enum"],
            customTypes: ["Color"],
          },
        }
      );
    })(),
  };
}
