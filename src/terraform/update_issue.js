module.exports = ({github, context}) => {
    const { ENVIRONMENT, APPLICATION_NAME } = process.env;

    const title_environment = ENVIRONMENT === 'Production' ? 'Production' : 'Staging';

    const issue_title = '[SSO Onboarding Request] [' + title_environment + ']: ' + APPLICATION_NAME

    github.rest.issues.update({
        issue_number: context.issue.number,
        owner: context.repo.owner,
        repo: context.repo.repo,
        title: issue_title
    });

    github.rest.issues.addLabels({
        issue_number: context.issue.number,
        owner: context.repo.owner,
        repo: context.repo.repo,
        labels: [ title_environment.toLowerCase() ]
    });
}