/*@ngInject*/
export function RoutesConfig($locationProvider, $urlRouterProvider) {
    // $locationProvider.html5Mode({
    //   enabled:true,
    //   requireBase:false
    // });

    const defaultPage = '/summary';
    $urlRouterProvider.otherwise(defaultPage);
    $locationProvider.html5Mode(true);
}
