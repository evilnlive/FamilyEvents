import { Elm } from "./Main.elm";

const apiHost = import.meta.env.API_HOST || "http://localhost:5000";

console.log("API_HOST", apiHost);

Elm.Main.init({
  node: document.querySelector("#app"),
  flags: apiHost,
});
