import { Application } from "@hotwired/stimulus";
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading";
import "chart.js";

const application = Application.start();
eagerLoadControllersFrom("controllers", application);
