/**
 * @ngdoc directive
 * @name lightning.directive:wordCloud
 * @restrict E
 * @author Claire Do
 *
 * @description
 * Word cloud visualization for trending searches using AnyChart (https://www.anychart.com)
 * NOTE!! AnyChart is a commercial product. Code in this project serves as an example of the library's capabilities
 * To use AnyChart in implementations, contact https://www.anychart.com/buy/ 
 */  
/*@ngInject*/
export function wordCloud($document) {
    var directive = {
        restrict: 'E',
        transclude: true,
        scope: {},
        link: {
            post: function ($scope, element, $attrs) {
                // console.log("wordCloudDirective=======");

                setTimeout(function(){
                    var currentPage = document.getElementById("summaryPage");
                    var response = angular.element(currentPage).scope().trendingSearchesResponse.facets.query_alias.filters;
                    // console.log(response);

                    var data = [];

                    var wordCloudTitle = "Global trending searches";

                    for(var i=0; i < response.length; i++) {
                        var item = response[i];

                        data.push({
                            "x": item.val,
                            "value": item.count
                        });
                    }

                    renderWordCloud("tagCloud", wordCloudTitle, data);

                }, 2000);

                function renderWordCloud(container, title, wordCloudData) {

                    anychart.onDocumentReady(function() {
                        var data = wordCloudData;
                      
                       // create a tag (word) cloud chart
                        var chart = anychart.tagCloud(data);

                        var background = chart.background();
                        background.fill({
                            keys: ['#FFFFFF','#FFFFFF']
                        });
                      
                         // set a chart title
                        // chart.title(title)
                        // set an array of angles at which the words will be laid out
                        chart.angles([0])
                        // enable a color range
                        // chart.colorRange(true);
                        // set the color range length
                        // chart.colorRange().length('80%');
                        // chart.mode("rect");
                        // chart.textSpacing(15);
                      
                        // display the word cloud chart
                        chart.container(container);
                        chart.draw();

                        // add an event listener
                        chart.listen("pointClick", function(e){
                        var url = "/search?q=" + e.point.get("x");
                        window.open(url, "_self");
                        });
                    });
                    
                }
            }
        },
        template: function (e, attrs) {
            var html = '';

            return html;
        }
    };

    return directive;
}

