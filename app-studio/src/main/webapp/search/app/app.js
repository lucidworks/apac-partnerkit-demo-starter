'use strict';
const BUILD_PATH = '/dist/';
const basePath = (document.getElementsByTagName('base')[0] || {href: ''}).href;
__webpack_public_path__ = window.__webpack_public_path__ = basePath.replace(/\/$/, '') + BUILD_PATH;

import '../../styles/twigkit.less';

import {RoutesModule} from './routes/routes.module.js';
import {SearchController} from './controllers/search.controller';
import {LoginController} from "./controllers/login.controller";
import {ServicesModule} from "./services/services.module";
import {DirectivesModule} from "./directives/directives.module.js";

let appModule = angular
    .module('appStudioSearch', [
        , 'ui.router'
        , 'ngAnimate'
        , 'lightning'
        , RoutesModule.name
        , DirectivesModule.name
        , ServicesModule.name
    ])
    .run(['$rootScope', '$window', '$location', '$twigkit', function ($rootScope, $window, $location, $twigkit) {
        $rootScope.$on('response_response_error', function (response) {
            $rootScope.showErrorModal = true;
        });

        $rootScope.$on('httpInterceptorError', function (event, error) {
            if ((error.status == '401' || error.status == '403') &&
                (error.config.url.indexOf('twigkit/api') !== -1 ||
                    error.config.url.indexOf('twigkit/services') !== -1 ||
                    error.config.url.indexOf('twigkit/secure/services') !== -1 ||
                    error.config.url.indexOf('views/') !== -1
                )) {
                // Error was a 403 and URL was a non-user facing path - redirect to login
                $rootScope.$broadcast('twigkitApi403', { error: error, url: $location.url() });

                var loginPath = $twigkit.getContextPath('/') + $twigkit.getConstant('loginPage', 'login/');

                // If we are already on the login page, do not redirect
                if ($window.location.pathname !== loginPath ) {
                    $window.location.href = loginPath;
                }

                // Uncomment next block to implement custom redirect logic. You must comment out the previous lines that
                // redirect to the login page as well
                // var redirectPath = $window.location.href; // redirects to last page user was on before error
                // $window.location.href = redirectPath;
            }
        });

        $rootScope.closeErrorModal = function () {
            $rootScope.showErrorModal = false;
        }
    }])
    .controller('searchCtrl', SearchController)
    .controller('loginCtrl', LoginController);

angular.bootstrap(document, ['appStudioSearch']);
