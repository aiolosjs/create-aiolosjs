<% if(fCreate || fUpdate || fDelete) { %>
import { message } from 'antd';
<% } %>
import { Reducer, Effect } from 'umi';
import { queryGet, <% if(fCreate) { %>createPost,<% } %> <% if(fUpdate) { %> updatePut,<% } %> <% if(fDelete) { %>remove, <% } %>  } from '@/services/api';
import { ITableData } from '@/utils/types';
<% if(fCreate || fUpdate ) { %>
import { delay } from '@/utils/utils';
<% } %>

export interface <%= firstUpperCaseProjectName%>DataProps {
  id: number;
  name: string;
  sex: string;
  remark: string;
}

export interface <%= firstUpperCaseProjectName%>State {
  tableData: ITableData<<%= firstUpperCaseProjectName%>DataProps>;
  <% if(fCreate || fUpdate) { %>
  modalVisible?: boolean;
  confirmLoading?: boolean;
  <% } %>
  <% if(fQueryDetail) { %>
  detailInfo: Partial<<%= firstUpperCaseProjectName%>DataProps>;
  <% } %>
}

export interface <%= firstUpperCaseProjectName%>ModelType {
  namespace: '<%= lowerCaseProjectName%>';
  state: <%= firstUpperCaseProjectName%>State;
  effects: {
    fetch: Effect;
    <% if(fCreate) { %>
    create: Effect;
    <% } %>
    <% if(fUpdate) { %>
    update: Effect;
    <% } %>
    <% if(fDelete) { %>
    remove: Effect;
    <% } %>
    <% if(fQueryDetail) { %>
    fetchDetailInfo: Effect;
    <% } %>
  };
  reducers: {
    <% if(fCreate || fUpdate) { %>
    modalVisible: Reducer<<%= firstUpperCaseProjectName%>State>;
    changgeConfirmLoading: Reducer<<%= firstUpperCaseProjectName%>State>;
    <% } %>
    save: Reducer<<%= firstUpperCaseProjectName%>State>;
    clear: Reducer<<%= firstUpperCaseProjectName%>State>;
  };
}

const <%= firstLowerCaseProjectName%>Model %>: <%= firstUpperCaseProjectName%>ModelType = {
  namespace: '<%= lowerCaseProjectName%>',
  state: {
    tableData: {
      list: [],
      pagination: {},
    },
    <% if(fCreate || fUpdate) { %>
    modalVisible: false,
    confirmLoading: false,
    <% } %>

    <% if(fQueryDetail) { %>
    detailInfo: {},
    <% } %>
  },
  effects: {
    *fetch({ payload }, { call, put }) {
      const response = yield call(
        queryGet,
        { ...payload?.query, ...payload?.pagination },
        '/api-user/v1/cms/user-staff',
      );

      if (response) {
       const { code, result } = response;
        if (code === '0') {
          const { records = [], current = 1, total = 1, size = 50 } = result ?? {
            records: [],
            current: 1,
            total: 0,
            size: 10,
          };
          yield put({
            type: 'save',
            payload: {
              tableData: {
                list: records,
                pagination: {
                  current: current - 0,
                  total,
                  pageSize: size,
                },
              },
            },
          });
        }
      }
    },
    <% if(fUpdate) { %>
    *update({ payload }, { call, put }) {
      yield put({
        type: 'changgeConfirmLoading',
        payload: {
          confirmLoading: true,
        },
      });
      yield call(delay);
      const response = yield call(
        updatePut,
        {...payload?.form},
        '/api-user/v1/cms/user-staff',
      );
      yield put({
        type: 'changgeConfirmLoading',
        payload: {
          confirmLoading: false,
        },
      });
      if (response) {
        const { code } = response;
        if (code === '0') {
          yield put({
            type: 'modalVisible',
            payload: {
              modalVisible: false,
            },
          });
          yield put.resolve({
            type: 'fetch',
            payload,
          });

          message.success('修改成功');
        }
      }
    },
    <% } %>

    <% if(fCreate) { %>
    *create({ payload }, { call, put }) {
      yield put({
        type: 'changgeConfirmLoading',
        payload: {
          confirmLoading: true,
        },
      });
      yield call(delay);
      const response = yield call(
        createPost,
        {...payload?.form},
        '/api-user/v1/cms/user-staff',
      );
      yield put({
        type: 'changgeConfirmLoading',
        payload: {
          confirmLoading: false,
        },
      });
      if (response) {
        const { code } = response;
        if (code === '0') {
          yield put({
            type: 'modalVisible',
            payload: {
              modalVisible: false,
            },
          });
          yield put.resolve({
            type: 'fetch',
            payload,
          });

          message.success('添加成功');
        }
      }
    },
    <% } %>
    <% if(fDelete) { %>
    *remove({ payload }, { call, put }) {
      const response = yield call(
        updatePut,
        {...payload?.form},
        '/api-user/v1/cms/user-staff',
      );
      if (response) {
        const { code } = response;
        if (code === '0') {
          
          yield put.resolve({
            type: 'fetch',
            payload,
          });

          message.success('删除成功');
        }
      }
    },
    <% } %>
    <% if(fQueryDetail) { %>
    *fetchDetailInfo({ payload }, { call, put }) {
      const response = yield call(queryGet, payload, '/sys/standardtable/detail');
      if (response) {
        const { code, result } = response;
        if (code === '0' && result) {
          yield put({
            type: 'save',
            payload: {
              detailInfo: result,
            },
          });
        }
      }
    },
    <% } %>
  },
  reducers: {
    <% if(fCreate || fUpdate) { %>
    modalVisible(state, { payload }) {
      return {
        ...state,
        ...payload,
      };
    },
    changgeConfirmLoading(state, { payload }) {
      return {
        ...state,
        ...payload,
      };
    },
    <% } %>
    save(state, { payload }) {
      return {
        ...state,
        ...payload,
      };
    },
    // @ts-ignore
    clear(state) {
      return {
        ...state,
        modalVisible: false,
        confirmLoading: false,
      };
    },
  },
};

export default <%= firstLowerCaseProjectName%>Model %>;
