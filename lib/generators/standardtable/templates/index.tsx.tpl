import React, { useEffect, useState, useRef } from 'react';
import { Button, Card, Modal, Popconfirm, Row, Col, Tooltip, Drawer } from 'antd';
import { EditOutlined, DeleteOutlined, PlusOutlined } from '@ant-design/icons';

import AuthBlock from '@/components/AuthBlock';
import { useSelector, useDispatch } from 'umi';
import { useQueryFormParams } from '@/utils/hooks';
import SearchForms from '@/components/SearchForm';
import TableList from '@/components/TableList';
import { formaterObjectValue, formItemAddInitValue } from '@/utils/utils';
import { RenderFormItemProps } from '@/core/common/renderFormItem';

import { PageHeaderWrapper } from '@ant-design/pro-layout';
import { <%= firstUpperCaseProjectName%>DataProps } from './model';
import DetailFormInfo, { ModelRef } from './ModalDetailForm';
import DetailInfo from './Detail';

import { OperatorKeys, OperatorType, IRootState } from './interface';

import pageConfig from './pageConfig';

const operatorTypeDic: OperatorType = {
  create: '新建用户',
  update: '修改用户',
};

export default (): React.ReactNode => {
  const dispatch = useDispatch();
  const { <%= lowerCaseProjectName%>, loading } = useSelector((state: IRootState) => state);
  const { modalVisible, confirmLoading } = <%= lowerCaseProjectName%>;

  const [payload, { setQuery, setPagination, setFormAdd, setFormUpdate }] = useQueryFormParams();
  const modelReduceType = useRef<OperatorKeys>('fetch');
  const detailFormRef = useRef<ModelRef | null>(null);

  const { searchForms = [], tableColumns = [], detailFormItems = [] } = pageConfig<
    <%= firstUpperCaseProjectName%>DataProps
  >();

  const [modalTitle, setModalTitle] = useState<string | undefined>();
  const [currentItem, setCurrentItem] = useState<<%= firstUpperCaseProjectName%>DataProps | {}>({});
  const [modalType, setModalType] = useState<OperatorKeys>();
  const [formItems, setFormItems] = useState<RenderFormItemProps[]>([]);
  const [drawerVisible, setDrawerVisible] = useState(false);

  useEffect(() => {
    dispatch({
      type: `<%= lowerCaseProjectName%>/${modelReduceType.current}`,
      payload,
    });
  }, [payload]);

  const updateFormItems = (record = {}) => {
    const newFormItems = formItemAddInitValue([...detailFormItems], record);
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

  const showDrawer = (record: <%= firstUpperCaseProjectName%>DataProps | {}) => {
    setDrawerVisible(true);
    setCurrentItem(record);
  };

  const hideDrawer = () => {
    setDrawerVisible(false);
  };

  const deleteTableRowHandle = (id: number) => {
    modelReduceType.current = 'remove';
    setFormUpdate({ id });
  };

  const modalOkHandle = async () => {
    const fieldsValue = await detailFormRef.current?.form?.validateFields();

    const fields = formaterObjectValue(fieldsValue);
    if (modalType === 'create') {
      modelReduceType.current = 'create';
      setFormAdd(fields);
    } else if (modalType === 'update') {
      modelReduceType.current = 'update';
      setFormUpdate(fields);
    }
  };

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
                <Col span={24}>
                  <a onClick={() => showDrawer(record)}>查看详情</a>
                </Col>
              </Row>
            </div>
          );
        },
      },
    ];
  };

  const renderTableList = () => {
    const tableLoading = loading.models.<%= lowerCaseProjectName%>;
    const {
      tableData: { list, pagination },
    } = <%= lowerCaseProjectName%>;
    const newTableColumns = [...tableColumns, ...extraTableColumnRender()];

    function onChange(current: number, pageSize?: number) {
      modelReduceType.current = 'fetch';
      setPagination({ current, pageSize });
    }

    return (
      <TableList<<%= firstUpperCaseProjectName%>DataProps>
        bordered={false}
        loading={tableLoading}
        columns={newTableColumns}
        dataSource={list}
        pagination={{ pageSize: 10, onChange, ...pagination }}
      />
    );
  };

  return (
    <PageHeaderWrapper title={false}>
      <Card bordered={false}>
        <div className="tableList">
          <div className="tableList-searchform">{renderSearchForm()}</div>
          <div className="tableList-operator">
            <Button
              icon={<PlusOutlined />}
              type="primary"
              onClick={() => showModalVisibel('create', {})}
            >
              新建
            </Button>
          </div>
          {renderTableList()}
        </div>
      </Card>
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
    </PageHeaderWrapper>
  );
};
