import { message } from 'antd';
import { Reducer, Effect } from 'umi';
import { query, create, update, remove, queryPost } from '@/services/api';
import { ITableData } from '@/utils/types';
import { delay } from '@/utils/utils';

export interface <%= firstUpperCaseProjectName%>DataProps {
  id: number;
  name: string;
  sex: string;
  remark: string;
}

export interface <%= firstUpperCaseProjectName%>State {
  tableData: ITableData<<%= firstUpperCaseProjectName%>DataProps>;
  modalVisible?: boolean;
  confirmLoading?: boolean;
  detailInfo: Partial<<%= firstUpperCaseProjectName%>DataProps>;
}

export interface <%= firstUpperCaseProjectName%>ModelType {
  namespace: '<%= lowerCaseProjectName%>';
  state: <%= firstUpperCaseProjectName%>State;
  effects: {
    fetch: Effect;
    create: Effect;
    update: Effect;
    remove: Effect;
    fetchDetailInfo: Effect;
  };
  reducers: {
    modalVisible: Reducer<<%= firstUpperCaseProjectName%>State>;
    changgeConfirmLoading: Reducer<<%= firstUpperCaseProjectName%>State>;
    save: Reducer<<%= firstUpperCaseProjectName%>State>;
    clear: Reducer<<%= firstUpperCaseProjectName%>State>;
  };
}

const <%= projectName%>ModelType: <%= firstUpperCaseProjectName%>ModelType = {
  namespace: '<%= lowerCaseProjectName%>',
  state: {
    tableData: {
      list: [],
      pagination: {},
    },
    modalVisible: false,
    confirmLoading: false,
    detailInfo: {},
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
  },
  reducers: {
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

export default <%= firstUpperCaseProjectName%>ModelType;
