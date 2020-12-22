/**
 * @ngdoc directive
 * @name lightning.directive:idEncoder
 * @restrict E
 * @author Claire Do
 *
 * @description
 * Encodes document's id and stores the value in a new field
 *
 */
/*@ngInject*/
export function idEncoder() {
    var directive = {
        restrict: 'E',
        transclude: true,
        scope: {},
        link: {
            post: function ($scope) {
                var valueToEncode = $scope.$parent.result.fields.id.val[0];
                var encoded = btoa(valueToEncode);

                $scope.$parent.result.fields.pageId = encoded;
            }
        },
        template: function (e, attrs) {
            var html = '<ng-transclude></ng-transclude>';

            return html;
        }
    };
  
    return directive;
  }
