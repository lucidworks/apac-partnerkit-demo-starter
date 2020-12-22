/*@ngInject*/
export function LoginController($scope, $rootScope) {
    $scope.application_name = $rootScope.application_name;

    checkForLoginError();

    function checkForLoginError() {
        let queryParamStr = window.location.search;
        if (queryParamStr.indexOf('login_error') > -1) {
            $scope.error = true;
        }
    }

    $scope.changedValue = function (item) {
        // TODO: if item not null then activate button
        $scope.topic = item.id;
    }
}