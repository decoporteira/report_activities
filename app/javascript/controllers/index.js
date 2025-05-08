import { application } from "controllers/application";
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading";

eagerLoadControllersFrom("controllers", application);
import ThemeController from "./theme_controller";
application.register("theme", ThemeController);
