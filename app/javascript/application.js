// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import {initializeFaro} from '@grafana/faro-web-sdk';

const faroEndpoint = document
    .querySelector('meta[name="faro-endpoint"]')
    ?.getAttribute('content');

const apiKey = document
    .querySelector('meta[name="faro-api-key"]')
    ?.getAttribute('content');

const appName = document
    .querySelector('meta[name="app-name"]')
    ?.getAttribute('content');

initializeFaro({
    url: faroEndpoint,
    apiKey: apiKey,
    app: {
        name: appName,
    }
});