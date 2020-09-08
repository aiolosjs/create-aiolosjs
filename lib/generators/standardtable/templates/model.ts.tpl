<% if(fCreate || fUpdate || fDelete) { %>
import { message } from 'antd';
<% } %>
import { Reducer, Effect } from 'umi';
import { <% if(fQueryDetail) { %>query,<% } %> create,<% if(fUpdate) { %> update,<% } %> <% if(fDelete) { %>remove, <% } %> queryPost } from '@/services/api';
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
      const response = yield call(queryPost, payload, '/sys/standardtable/list');
      if (response) {
        const { code, body } = response;
        if (code === 200) {
          yield put({
            type: 'save',
            payload: {
              tableData: body,
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
      const response = yield call(update, payload, '/sys/standardtable/update');
      yield put({
        type: 'changgeConfirmLoading',
        payload: {
          confirmLoading: false,
        },
      });
      if (response) {
        const { code, body } = response;
        if (code === 200) {
          yield put({
            type: 'modalVisible',
            payload: {
              modalVisible: false,
            },
          });
          yield put({
            type: 'save',
            payload: {
              tableData: body,
            },
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
      const response = yield call(create, payload, '/sys/standardtable/add');
      yield put({
        type: 'changgeConfirmLoading',
        payload: {
          confirmLoading: false,
        },
      });
      if (response) {
        const { code, body } = response;
        if (code === 200) {
          yield put({
            type: 'modalVisible',
            payload: {
              modalVisible: false,
            },
          });
          yield put({
            type: 'save',
            payload: {
              tableData: body,
            },
          });
          message.success('添加成功');
        }
      }
    },
    <% } %>
    <% if(fDelete) { %>
    *remove({ payload }, { call, put }) {
      const response = yield call(remove, payload, '/sys/standardtable/delete');
      if (response) {
        const { code, body } = response;
        if (code === 200) {
          yield put({
            type: 'save',
            payload: {
              tableData: body,
            },
          });
          message.success('删除成功');
        }
      }
    },
    <% } %>
    <% if(fQueryDetail) { %>
    *fetchDetailInfo({ payload }, { call, put }) {
      const response = yield call(query, payload, '/sys/standardtable/detail');
      if (response) {
        const { code, body } = response;
        if (code === 200) {
          yield put({
            type: 'save',
            payload: {
              detailInfo: body,
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
