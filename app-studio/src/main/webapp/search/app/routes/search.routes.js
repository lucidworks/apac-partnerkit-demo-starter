let searchTemplate = require('../../../views/search.html');
let errorTemplate = require('../../../views/error.html');
let defaultPage = 'summary';

/*@ngInject*/
export function SearchRoutes($stateProvider) {

    $stateProvider
        .state('index', {
            url: '/',
            templateUrl: function () {

                return 'views/' + defaultPage + '.html';
            },
            controller: 'searchCtrl'
        })
        .state('search', {
            url: '/search',
            // template: `<search></search>`
            // Need to use controller because Appkit Lightning uses shared scope ($rootScope.$$lastChild)
            controller: 'searchCtrl',
            template: searchTemplate
        })
        .state('login', {
            url: '/login/',
            controller: 'loginCtrl'
        })
        .state('loginNoSlash', {
            url: '/login',
            controller: 'loginCtrl'
        })
        .state('page', {
            url: '/{slug}',
            templateUrl: function (params) {

                if (params.slug === '') {
                    params.slug = defaultPage;
                }

                return 'views/' + params.slug + '.html';
            },
            controller: 'searchCtrl'
        })
        .state('details', {
            url: '/{slug}/{id}',
            templateUrl: function (params) {

                if (params.slug === '') {
                    params.slug = defaultPage;
                }
                if (params.id === '') {
                    return 'views/' + params.slug + '.html';
                }
                else {
                    return 'views/' + params.slug + '-detail.html';
                }
            },
            controller: 'searchCtrl',
        })
        .state('error', {
            url: '/error',
            template: errorTemplate
        });
}
