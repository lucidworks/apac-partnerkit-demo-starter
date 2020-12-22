/*@ngInject*/
export function SearchController($scope, $stateParams,$twigkit) {
    $scope.params = $stateParams;

    $twigkit.getUser()
        .then(function (user) {
            $scope.user = user;
        });

    $scope.logout = function() {
        window.location.href = "/logout/";
    }

    $scope.getSortedList = function (farray) {
        if (angular.isDefined(farray)) {
          var unordered = farray;
          var ordered = {};
          Object.keys(unordered).sort().forEach(function(key) {
            ordered[key] = unordered[key];
          });
          farray = ordered;
        }
        return farray;
    };

}
