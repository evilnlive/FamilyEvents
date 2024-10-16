import { Elm } from "./Main.elm";

const apiUrl = import.meta.env.API_URL || "http://localhost:5000";

Elm.Main.init({
  node: document.querySelector("#app"),
  flags: apiUrl,
});
