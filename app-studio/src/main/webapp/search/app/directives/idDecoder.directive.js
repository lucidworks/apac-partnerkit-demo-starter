/**
 * @ngdoc directive
 * @name lightning.directive:idDecoder
 * @restrict E
 * @author Claire Do
 *
 * @description
 * Decodes document's id and stores the value in a new field
 *
 */
/*@ngInject*/
export function idDecoder($document) {
    var directive = {
        restrict: 'E',
        transclude: true,
        scope: {},
        link: {
            post: function ($scope) {
                // console.log("DECODING ID");
                var valueToDecode = $scope.$parent.params.id;
                var decoded = atob(valueToDecode);

                $scope.$parent.pageId = decoded;
            }
        },
        template: function (e, attrs) {
            var html = '<ng-transclude></ng-transclude>';

            return html;
        }
    };
  
    return directive;
  }
