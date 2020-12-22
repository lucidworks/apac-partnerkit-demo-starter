import {RoutesConfig} from './routes.config';
import {SearchRoutes} from './search.routes';

export const RoutesModule = angular.module('as.routes', [])
    .config(RoutesConfig)
    .config(SearchRoutes);

