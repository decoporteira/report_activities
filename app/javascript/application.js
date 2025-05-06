import { Application } from "@hotwired/stimulus"
//import { definitionsFromContext } from "@hotwired/stimulus-loading"
import "controllers";

const application = Application.start();
const context = require.context("controllers", true, /\.js$/);
application.load(definitionsFromContext(context));
