// import * as fs from 'node:fs';
const fs = require('fs');

module.exports = ({github, context}) => {
    var environment       = "ENVIRONMENT=";
    var environment_lower = "ENVIRONMENT_LOWER=";

    for (var label of context.payload.pull_request.labels) {
        if (label.name === 'staging') {
            environment       += 'Staging,'
            environment_lower += 'staging,'
        }

        if (label.name === 'production') {
            environment       += 'Production,'
            environment_lower += 'production,'
        }
    }

    environment       += '\n'
    environment_lower += '\n'

    // Output environment and environment_lower to the environment variables
    fd = fs.openSync(process.env.GITHUB_ENV, 'a');
    fs.appendFileSync(fd, environment);
    fs.appendFileSync(fd, environment_lower);
    fs.closeSync(fd);
}