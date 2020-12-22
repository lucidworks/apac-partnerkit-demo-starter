/*@ngInject*/
export function SampleDirective(CommonService) {
    var directive = {
        restrict: 'E',
        transclude: true,
        scope: {},
        link: {
            post: function ($scope, elem, $attrs) {

                $scope.$on('query_' + $attrs.query + '_updated', function () {
                    $scope.text = CommonService.sampleFunct();
                })
            }
        },
        template: function (e, attrs) {
            var html = '<div>\n'+
                '<p>'+
                'My Query value is: <span style="font-weight:700;">{{text}}</span>'+
                '<p>'+
                '</div>';
            return html;
        }
    };

    return directive;
}
