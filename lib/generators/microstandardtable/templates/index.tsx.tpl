import React, { useEffect, <% if(fCreate || fUpdate || fQueryDetail) { %>useState,<% } %> useRef } from 'react';
import { <% if(fCreate) { %>Button,<% } %> Card, <% if(fCreate || fUpdate) { %>Modal,<% } %> <% if(fDelete) { %>Popconfirm,<% } %> <% if(fDelete || fUpdate || fQueryDetail) { %>Row, Col,<% } %> <% if(fDelete || fUpdate) { %>Tooltip,<% } %> <% if(fQueryDetail) { %>Drawer<% } %> } from 'antd';
<% if(fCreate || fUpdate || fDelete) { %>
import { <% if(fUpdate) { %>EditOutlined,<% } %> <% if(fDelete) { %>DeleteOutlined,<% } %> <% if(fCreate) { %>PlusOutlined<% } %> } from '@ant-design/icons';
<% } %>

// @ts-ignore
import clonedeep from 'lodash.clonedeep';
import { useSelector, useDispatch } from 'umi';
import { useQueryFormParams,useCalcTableBodyMaxHeight } from '@/utils/hooks';
import SearchForms from '@/components/SearchForm';
import TableList from '@/components/TableList';
import { formaterObjectValue, <% if(fCreate || fUpdate) { %>formItemAddInitValue<% } %> } from '@/utils/utils';
<% if(fCreate || fUpdate) { %>
import { RenderFormItemProps } from '@/core/common/renderFormItem';
<% } %>

import { <%= firstUpperCaseProjectName%>DataProps } from './model';
<% if(fCreate || fUpdate) { %>
import DetailFormInfo, { ModelRef } from './ModalDetailForm';
<% } %>

<% if(fQueryDetail) { %>
import DetailInfo from './Detail';
<% } %>

import { OperatorKeys, <% if(fCreate || fUpdate) { %>OperatorType,<% } %> IRootState } from './interface';

import pageConfig from './pageConfig';

<% if(fCreate || fUpdate) { %>
const operatorTypeDic: OperatorType = {
 <% if(fCreate) { %> create: '新建用户',<% } %>
 <% if(fUpdate) { %> update: '修改用户',<% } %>
};
<%}%>

export default (): React.ReactNode => {
  const dispatch = useDispatch();
  const { <%= lowerCaseProjectName%>, loading } = useSelector((state: IRootState) => state);
  const [payload, { setQuery, setPagination, <% if(fCreate || fUpdate) { %>setFormAdd,<% } %>  <% if(fUpdate || fDelete) { %>setFormUpdate,<% } %> }] = useQueryFormParams();
  const modelReduceType = useRef<OperatorKeys>('fetch');
  const { searchForms = [], tableColumns = [],  <% if(fCreate || fUpdate) { %>detailFormItems = []<% } %> } = pageConfig<
    <%= firstUpperCaseProjectName%>DataProps
  >();
  <% if(fCreate || fUpdate) { %>
  const { modalVisible, confirmLoading } = <%= lowerCaseProjectName%>;
  const detailFormRef = useRef<ModelRef | null>(null);
  const [modalTitle, setModalTitle] = useState<string | undefined>();
  const [<% if(fQueryDetail) { %>currentItem<% } %>, setCurrentItem] = useState<<%= firstUpperCaseProjectName%>DataProps | {}>({});
  const [modalType, setModalType] = useState<OperatorKeys>();
  const [formItems, setFormItems] = useState<RenderFormItemProps[]>([]);

  <% } %>

  <% if(fQueryDetail) { %>
  const [drawerVisible, setDrawerVisible] = useState(false);
  <% } %>

  useEffect(() => {
    dispatch({
      type: `<%= lowerCaseProjectName%>/${modelReduceType.current}`,
      payload,
    });
  }, [payload]);

  
  <% if(fCreate || fUpdate) { %>
  const updateFormItems = (record = {}) => {
    const newFormItems = formItemAddInitValue([...clonedeep(detailFormItems)], record);
    setFormItems([...newFormItems]);
  };

  const changeModalVisibel = (flag: boolean) => {
    dispatch({
      type: '<%= lowerCaseProjectName%>/modalVisible',
      payload: {
        modalVisible: flag,
      },
    });
  };
  <% } %>

  <% if(fCreate || fUpdate) { %>

  const showModalVisibel = (type: OperatorKeys, record: <%= firstUpperCaseProjectName%>DataProps | {}) => {
    updateFormItems(record);
    setModalTitle(operatorTypeDic[type]);
    changeModalVisibel(true);
    setModalType(type);
    setCurrentItem(record);
  };

  const hideModalVisibel = () => {
    changeModalVisibel(false);
    setCurrentItem({});
  };

  <% } %>

  
  <% if(fQueryDetail) { %>
  const showDrawer = (record: <%= firstUpperCaseProjectName%>DataProps | {}) => {
    setDrawerVisible(true);
    setCurrentItem(record);
  };

  const hideDrawer = () => {
    setDrawerVisible(false);
  };
  <% } %>

  <% if(fDelete) { %>
  const deleteTableRowHandle = (id: number) => {
    modelReduceType.current = 'remove';

    setFormUpdate({ id });
  };
  <% } %>

  <% if(fCreate || fUpdate) { %>
  const modalOkHandle = async () => {
    const fieldsValue = await detailFormRef.current?.form?.validateFields();

    const fields = formaterObjectValue(fieldsValue);
    

    if (modalType === 'create') {
      modelReduceType.current = 'create';
      setFormAdd(fields);
    } <% if(fUpdate) { %>else if (modalType === 'update') {
      modelReduceType.current = 'update';
      setFormUpdate(fields);
    }<% } %>
  };
  <% } %>

  const renderSearchForm = () => {
    function onSubmit(queryValues: any) {
      modelReduceType.current = 'fetch';
      const query = formaterObjectValue(queryValues);
      setQuery(query);
    }

    function onReset() {
      modelReduceType.current = 'fetch';
      setQuery({});
    }

    return <SearchForms formItems={searchForms} onSubmit={onSubmit} onReset={onReset} />;
  };

  <% if(fDelete || fUpdate || fQueryDetail) { %>
  const extraTableColumnRender = () => {
    return [
      {
        title: '操作',
        width: 90,
        dataIndex: 'actions',
        render: (_: any, record: <%= firstUpperCaseProjectName%>DataProps) => {
          return (
            <div>
              <Row>
               <% if(fUpdate) { %> 
                <Col span={12}>
                  <Tooltip title="编辑">
                    <a
                      onClick={() => {
                        showModalVisibel('update', record);
                      }}
                    >
                      <EditOutlined style={{ fontSize: 18, color: 'rgba(0, 0, 0, 0.65)' }} />
                    </a>
                  </Tooltip>
                </Col>
                <% } %>

                <% if(fDelete) { %> 
                <Col span={12}>
                  <Popconfirm
                    title="确定删除吗？"
                    placement="topRight"
                    onConfirm={() => {
                      deleteTableRowHandle(record.id);
                    }}
                  >
                    <Tooltip title="删除">
                      <a>
                        <DeleteOutlined style={{ fontSize: 18, color: 'rgba(0, 0, 0, 0.65)' }} />
                      </a>
                    </Tooltip>
                  </Popconfirm>
                </Col>
                <% } %>

                <% if(fQueryDetail) { %> 
                <Col span={24}>
                  <a onClick={() => showDrawer(record)}>查看详情</a>
                </Col>
                <% } %>
              </Row>
            </div>
          );
        },
      },
    ];
  };
  <% } %>

  const renderTableList = () => {
    const tableLoading = loading.models.<%= lowerCaseProjectName%>;
    const {
      tableData: { list, pagination },
    } = <%= lowerCaseProjectName%>;
    const newTableColumns = [...tableColumns, <% if(fDelete || fUpdate || fQueryDetail) { %>...extraTableColumnRender()<% } %>];

    function onChange(current: number, pageSize?: number) {
      modelReduceType.current = 'fetch';
      setPagination({ page: current, perPage: pageSize });
    }

    return (
      <TableList<<%= firstUpperCaseProjectName%>DataProps>
        bordered={false}
        loading={tableLoading}
        columns={newTableColumns}
        dataSource={list}
        pagination={{ pageSize: 10, onChange, ...pagination }}
        size="middle"
        scroll={{ y: useCalcTableBodyMaxHeight("<%= firstLowerCaseProjectName %>") }}
      />
    );
  };

  return (
    <>
      <Card bordered={false} id="<%= firstLowerCaseProjectName %>">
        <div 
          className="tableList" 
          style={{
            height: 'calc(100vh - 120px)',
            display: 'flex',
            flexDirection: 'column',
            overflow: 'hidden',
          }}
        >
          <div className="tableList-searchform">{renderSearchForm()}</div>
          <% if(fCreate) { %> 
           <div className="tableList-operator" style={{ paddingBottom: 10 }} >
            <Button
              icon={<PlusOutlined />}
              type="primary"
              onClick={() => showModalVisibel('create', {})}
            >
              新建
            </Button>
          </div>
          <% } %>
         
          {renderTableList()}
        </div>
      </Card>

      <% if(fCreate || fUpdate) { %>
      <Modal
        title={modalTitle}
        destroyOnClose
        visible={modalVisible}
        confirmLoading={confirmLoading}
        onCancel={hideModalVisibel}
        onOk={modalOkHandle}
      >
        <DetailFormInfo ref={detailFormRef} formItems={formItems} />
      </Modal>
      <% } %>

      <% if(fQueryDetail) { %>
      <Drawer
        destroyOnClose
        title="详情"
        width="50%"
        placement="right"
        onClose={hideDrawer}
        visible={drawerVisible}
        zIndex={100}
        style={{
          overflow: 'auto',
        }}
      >
        <DetailInfo currentItem={currentItem} />
      </Drawer>
      <% } %>
    </>
  );
};
