import { Elm } from "./Main.elm";

const apiHost = import.meta.env.VITE_API_HOST || "http://localhost:5000";

Elm.Main.init({
  node: document.querySelector("#app"),
  flags: apiHost,
});
