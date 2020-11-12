import React, { forwardRef, useImperativeHandle } from 'react';
import { Form, Row, Col } from 'antd';
import { FormInstance } from 'antd/es/form/Form';

import renderFormItem, { RenderFormItemProps } from '@/core/common/renderFormItem';
import { OperatorKeys } from './interface';

export type ModelRef = {
  form: FormInstance;
};

export interface ModalDetailFormProps {
  formItems: RenderFormItemProps[];
  currentItem?: { [key: string]: any };
  modalType?: OperatorKeys;
}

const ModalDetailForm = forwardRef<ModelRef, ModalDetailFormProps>(
  (props: ModalDetailFormProps, ref) => {
    const { formItems = [] } = props;
    const [form] = Form.useForm();
    useImperativeHandle(ref, () => ({
      form,
    }));

    const renderItem = () => {
      return formItems.map((item) => {
        const { colSpan = 8 } = item;

        return (
          <Col span={colSpan} key={item.name}>
            {renderFormItem(item)}
          </Col>
        );
      });
    };

    return (
      <Form form={form}>
        <Row gutter={24}>{renderItem()}</Row>
      </Form>
    );
  },
);

export default React.memo(ModalDetailForm);
