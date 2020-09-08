import { DvaLoadingState } from '@/utils/types';
import { <%= firstUpperCaseProjectName%>State } from './model';

export type OperatorKeys = 'fetch' | 'create' | 'update' | 'remove';
export type OperatorType = { [K in OperatorKeys]?: string };
export type IRootState = {
  <%= lowerCaseProjectName%>: <%= firstUpperCaseProjectName%>State;
  loading: DvaLoadingState;
};
